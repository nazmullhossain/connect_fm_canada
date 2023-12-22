import 'dart:io';
import 'dart:math';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectfm/app/data/models/social_user_model.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:connectfm/app/data/models/fm.dart';
import 'package:connectfm/app/data/models/login_model.dart';
import 'package:connectfm/app/modules/splash_page.dart';
import 'package:unique_identifier/unique_identifier.dart';
import '../../data/models/register_model.dart';
import '../../data/models/user_model.dart';
import 'package:waveui/waveui.dart';

class AppController extends GetxController {
  GetStorage localStorage = GetStorage();
  var lang = 0.obs;
  RxInt currentFMIndex = 0.obs;
  RxInt currentNavIndex = 0.obs;
  RxBool isPlaying = false.obs;
  RxBool isMute = false.obs;
  var radioList = <FM>[].obs;
  var userModel = Rxn<UserModel>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  bool isLoggedIn() {
    print(userModel.value?.token == null);
    print(userModel.value?.token);
    if (userModel.value?.token == null) {
      return auth.currentUser?.uid != null;
    }
    return true;
  }

  Future<void> autoLogin() async {
    if (auth.currentUser?.uid != null) {
      userModel.value = UserModel(
        email: auth.currentUser?.email,
        firstName: auth.currentUser?.displayName,
        mobile: auth.currentUser?.phoneNumber,
        token: auth.currentUser?.uid,
      );
      return;
    }
    var data = await localStorage.read('credential');
    if (data == null) {
      return;
    }
    LoginModel userCred = LoginModel.fromJson(data);
    var email = userCred.username;
    var password = userCred.password;

    if (email == null) {
      return;
    }
    if (password == null) {
      return;
    }
    await login(email, password, isAutologin: true).then((value) {
      if (value) {
        getLocalUser();
      }
    });
    return;
  }

  Future<UserModel?> getLocalUser() async {
    var value = await localStorage.read("user");
    if (value != null) {
      userModel.value = UserModel.fromJson(value);
    }
    return userModel.value;
  }

  Future<void> deleteAccount() async {
    var response = await http.get(
      Uri.parse(
          "http://stagingapp.connectfm.ca/connectfm-api/public/api/deleteAccount"),
      headers: {
        "Authorization": "Bearer ${userModel.value!.token!}",
      },
    );

    print(userModel.value!.token!);
    if (response.statusCode == 200) {
      // Handle success
      print('Account deleted successfully');
      await logout();
    } else {
      // Handle error
      print('Failed to delete account');
    }
  }

  logout() {
    localStorage.erase();
    if (auth.currentUser?.uid != null) {
      _googleSignIn.disconnect();
      auth.signOut();
    }
    Get.offAll(() => SplashPage());
    Get.deleteAll(force: true);
  }

  Future<bool> login(String email, String password,
      {bool isAutologin = false}) async {
    try {
      http.Response response = await http.post(Uri.parse(
        'http://stagingapp.connectfm.ca/connectfm-api/public/api/login?password=${Uri.encodeQueryComponent(password)}&email=${Uri.encodeQueryComponent(email)}',
      ));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        userModel.value = UserModel.fromJson(data);
        await localStorage.write("user", userModel.toJson());
        await localStorage.write(
          "credential",
          LoginModel(password: password, username: email).toJson(),
        );
        if (!isAutologin) {
          Get.back();
        }
        return true;
      } else {
        if (isAutologin) {
          await logout();
        } else {
          Get.dialog(
            WaveDialog(
              actionsText: ['Try again'],
              titleText: "Login failed",
              messageText: '${jsonDecode(response.body)['message']}.',
            ),
          );
        }
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInwithGoogle() async {
    try {
      final GoogleSignInAccount? _googleSignInAccount =
          await _googleSignIn.signIn().onError((error, stackTrace) {
        print(error);
        return null;
      });
      final GoogleSignInAuthentication? _googleSigninAuth =
          await _googleSignInAccount?.authentication;
      final AuthCredential _credential = GoogleAuthProvider.credential(
        accessToken: _googleSigninAuth?.accessToken,
        idToken: _googleSigninAuth?.idToken,
      );
      final authResult = await auth.signInWithCredential(_credential);
      if (authResult.user?.uid != null) {
        // If login is successfull post user data to api
        var authUser = authResult.user;
        await postSocialLogin(SocialUserModel(
          name: authUser?.displayName,
          email: authUser?.email,
          mobile: authUser?.phoneNumber,
          socialProfile: authUser?.photoURL,
        ));

        Get.offAll(() => SplashPage());
        Get.deleteAll(force: true);
      } else {
        WaveSnackbar.show(title: "Failed to login!");
      }
      return authResult.user?.uid == auth.currentUser?.uid;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    try {
      print("trying to sign in with Facebook");
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      print(
          "this is the access token ${loginResult.accessToken!.token.toString()}");
      final OAuthCredential facebookAuthCredential =
          await FacebookAuthProvider.credential(
              loginResult.accessToken?.token ?? "");
      var authResult = await auth.signInWithCredential(facebookAuthCredential);
      print("this is the data $authResult");
      if (authResult.user != null) {
        // If login is successfull post user data to api
        var authUser = authResult.user;
        await postSocialLogin(SocialUserModel(
          name: authUser?.displayName,
          email: authUser?.email,
          mobile: authUser?.phoneNumber,
          socialProfile: authUser?.photoURL,
        ));

        Get.offAll(() => SplashPage());
        Get.deleteAll(force: true);
      } else {
        WaveSnackbar.show(title: "Failed to login!");
      }
      return true;
    } catch (e) {
      WaveSnackbar.show(title: "Failed to login!");
      print("this is the fb login error: $e");
      return false;
    }
  }

  getApi(String url) async {
    try {
      // isDataLoading(true);
      http.Response response = await http.get(
        Uri.tryParse(url)!,
      );
      if (response.statusCode == 200) {
        ///data successfully
        var result = jsonDecode(response.body);
        return result;
      } else {
        ///error
      }
    } catch (e) {
      print('Error while getting data is $e');
    } finally {
      // isDataLoading(false);
    }
    return '';
  }

  Future<void> fetchRadioList() async {
    radioList.clear();
    await getApi(
            'http://stagingapp.connectfm.ca/connectfm-api/public/api/getStations')
        .then((value) {
      var x = value as List;
      x.forEach((element) {
        radioList.add(FM.fromJson(element));
        print(radioList.length);
      });
    });
  }

  Future<bool> createUser(RegisterModel model,
      {bool isDoubleBack = true}) async {
    try {
      print(model.toJson());
      http.Response response = await http.post(
          Uri.parse(
            'http://stagingapp.connectfm.ca/connectfm-api/public/api/register',
          ),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          },
          body: jsonEncode(model.toJson()),
          encoding: Encoding.getByName('utf-8'));

      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 201) {
        await login("${model.email}", "${model.password}");
        return true;
      } else {
        Get.dialog(
          WaveDialog(
            actionsText: ['Try again'],
            titleText: "Sign up failed",
            messageText: '${jsonDecode(response.body)['message']}.',
          ),
        );
        print('failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      Get.dialog(
        WaveDialog(
          actionsText: ['Try again'],
          titleText: "Sign up failed",
          messageText: '$e',
        ),
      );
      return false;
    }
  }

  Future<void> postSocialLogin(SocialUserModel socialUser) async {
    var connect = GetConnect();
    try {
      connect.post(
        "http://stagingapp.connectfm.ca/connectfm-api/public/api/socialMediaLogin",
        socialUser.toJson(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // ############################## LOCATION ##############################

  Future<void> updateLocation(BuildContext context) async {
    if (userModel.value?.token == null) {
      return;
    }
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;

    String? deviceId = await initUniqueIdentifierState();

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final Map<String, dynamic> body = {
      "deviceId": deviceId,
      "deviceType": Platform.isAndroid
          ? "Android"
          : Platform.isIOS
              ? "iOS"
              : "Unknown",
      "email": userModel.value?.email,
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "address": await getAddress(),
    };
    var req = await http.post(
        Uri.parse(
            'http://stagingapp.connectfm.ca/connectfm-api/public/api/saveLocation'),
        body: body);

    print(req.body);
  }

  Future<String> getAddress() async {
    try {
      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get the address from the coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // Return the first address found
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        return '${placemark.street}, ${placemark.locality}, ${placemark.country}';
      }
    } catch (e) {
      print(e);
    }

    return 'No address available';
  }

  Future<String?> initUniqueIdentifierState() async {
    try {
      return await UniqueIdentifier.serial;
    } on PlatformException {
      return 'Failed to get Unique Identifier';
    }
  }

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _handleLocationPermission(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      //Geolocator.openLocationSettings();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  // ######################## APPLE LOGIN ######################

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    print("trying to sign in with Apple");
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    final userCredential = await auth.signInWithCredential(oauthCredential);
    final firebaseUser = userCredential.user!;
    final firstName = appleCredential.givenName;
    final lastName = appleCredential.familyName;

    if (firstName != null || lastName != null) {
      final displayName = '$firstName $lastName';
      await firebaseUser
        ..updateDisplayName(displayName);
    }
    if (userCredential.user != null) {
      // If login is successfull post user data to api
      var authUser = userCredential.user;
      await postSocialLogin(SocialUserModel(
        name: authUser?.displayName,
        email: authUser?.email,
        mobile: authUser?.phoneNumber,
        socialProfile: authUser?.photoURL,
      ));

      Get.offAll(() => SplashPage());
      Get.deleteAll(force: true);
    }
  }
}
