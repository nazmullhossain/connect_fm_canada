import 'package:connectfm/app/components/social_login_view.dart';
import 'package:connectfm/app/modules/auth/signup_page.dart';

import '../root/app_controller.dart';
import 'auth_controller.dart';
import 'package:waveui/waveui.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final AuthController controller = AuthController();
  final AppController _controller = Get.find();
  bool isLoading = false;
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      isLoading: isLoading,
      isBlurred: true,
      appBar: WaveAppBar(
        isBlurred: true,
        title: "Login",
      ),
      backgroundColor: Get.theme.cardColor,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: controller.emailEditingController,
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch('$value')
                              ? null
                              : "Please Enter Correct Email";
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FluentIcons.mail_28_regular,
                            color: Colors.grey,
                          ),
                          hintText: "EMAIL",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: controller.passwordEditingController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a password!';
                          } else if (value.length < 3) {
                            return "Please provide password of 3 character";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FluentIcons.shield_28_regular,
                            color: Colors.grey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? FluentIcons.eye_28_regular
                                  : FluentIcons.eye_off_24_regular,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          hintText: "PASSWORD",
                        ),
                        obscureText: _obscureText,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FilledButton(
                  child: Text("SIGN IN"),
                  onPressed: _formKey.currentState?.validate() ?? false
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            _controller
                                .login(controller.emailEditingController.text,
                                    controller.passwordEditingController.text)
                                .then((value) {
                              setState(() {
                                isLoading = value;
                              });
                            });
                          }
                        }
                      : null,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New here?  ",
                      style: TextStyle(
                        // color: Colors.grey.shade900,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignUp());
                      },
                      child: Text(
                        "Sign up instead",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Center(child: SocialLoginView()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
