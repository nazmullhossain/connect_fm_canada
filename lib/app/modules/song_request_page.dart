import 'dart:convert';

import 'package:connectfm/app/data/models/song_req_model.dart';

import 'root/app_controller.dart';
import 'package:waveui/waveui.dart';
import 'package:http/http.dart' as http;

class SongReqPage extends StatefulWidget {
  SongReqPage({super.key});

  @override
  State<SongReqPage> createState() => _SongReqPageState();
}

class _SongReqPageState extends State<SongReqPage> {
  TextEditingController songted = TextEditingController();
  TextEditingController albumted = TextEditingController();
  TextEditingController artistted = TextEditingController();
  TextEditingController nameted = TextEditingController();
  TextEditingController emailted = TextEditingController();
  TextEditingController messageted = TextEditingController();

  String? nameError;
  String? emailError;
  String? songError;
  String? albumError;
  String? artistError;

  final AppController controller = Get.find();
  bool isValid = false;
  int radioIndex = 1;
  bool isBusy = false;
  @override
  void initState() {
    if (controller.isLoggedIn()) {
      nameted.text = controller.auth.currentUser?.displayName ??
          controller.userModel.value?.firstName ??
          "";
      emailted.text = controller.auth.currentUser?.email ??
          controller.userModel.value?.email ??
          "";
    }
    radioIndex = controller.currentFMIndex.value + 1;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      isLoading: isBusy,
      appBar: WaveAppBar(title: "Song request"),
      backgroundColor: Get.theme.cardColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: controller.radioList
                        .map((element) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text("${element.name}"),
                                selected: element.id == radioIndex,
                                onSelected: (value) => setState(() {
                                  radioIndex = element.id ?? 0;
                                }),
                              ),
                            ))
                        .toList(),
                  )),
              SizedBox(height: 12),
              WaveInputText(
                hint: "Name*",
                isEnabled: !controller.isLoggedIn(),
                errorText: nameError,
                backgroundColor: Colors.transparent,
                onTextChange: (input) {
                  validate();
                  if (input.isEmpty) {
                    setState(() {
                      nameError = "Please type your valid name";
                    });
                  } else {
                    setState(() {
                      nameError = null;
                    });
                  }
                },
                textEditingController: nameted,
              ),
              SizedBox(height: 12),
              WaveInputText(
                errorText: emailError,
                backgroundColor: Colors.transparent,
                hint: "Email*",
                isEnabled: !controller.isLoggedIn(),
                onTextChange: (input) {
                  validate();
                  if (!GetUtils.isEmail(input)) {
                    setState(() {
                      emailError = "Email is not valid";
                    });
                  } else {
                    setState(() {
                      emailError = null;
                    });
                  }
                },
                textEditingController: emailted,
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                hint: "Song*",
                errorText: songError,
                backgroundColor: Colors.transparent,
                onTextChange: (input) {
                  validate();
                  if (input.isEmpty) {
                    setState(() {
                      songError = "Please type a song name";
                    });
                  } else {
                    setState(() {
                      songError = null;
                    });
                  }
                },
                textEditingController: songted,
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                errorText: albumError,
                backgroundColor: Colors.transparent,
                onTextChange: (input) {
                  validate();
                },
                hint: "Album",
                textEditingController: albumted,
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                errorText: artistError,
                hint: "Artist",
                backgroundColor: Colors.transparent,
                onTextChange: (input) {
                  validate();
                },
                textEditingController: artistted,
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                hint: "Message*",
                backgroundColor: Colors.transparent,
                minLines: 5,
                textEditingController: messageted,
                onTextChange: (input) {
                  validate();
                },
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(
                child: Text("Submit"),
                onPressed: isValid
                    ? () async {
                        setState(() {
                          isBusy = true;
                        });
                        await makePostRequest();
                        setState(() {
                          isBusy = false;
                        });
                      }
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }

  validate() {
    if (nameted.text.isNotEmpty) {
      if (GetUtils.isEmail(emailted.text)) {
        if (songted.text.isNotEmpty) {
          if (messageted.text.isNotEmpty) {
            isValid = true;
            setState(() {});
          } else {
            isValid = false;
            setState(() {});
          }
        } else {
          isValid = false;
          setState(() {});
        }
      } else {
        isValid = false;
        setState(() {});
      }
    } else {
      isValid = false;
      setState(() {});
    }
  }

  makePostRequest() async {
    final uri = Uri.parse(
        'http://stagingapp.connectfm.ca/connectfm-api/public/api/createSongRequest');
    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http
        .post(
          uri,
          headers: headers,
          body: jsonEncode(SongReqModel(
            album: albumted.text,
            artist: artistted.text,
            customerName: nameted.text,
            email: emailted.text,
            gender: controller.userModel.value?.gender ?? "",
            message: messageted.text,
            phoneNumber: controller.auth.currentUser?.phoneNumber ??
                controller.userModel.value?.mobile ??
                "",
            song: songted.text,
            stationId: "$radioIndex",
          ).toJson()),
          encoding: encoding,
        )
        .whenComplete(() => Get.back());

    int statusCode = response.statusCode;
    var responseBody = jsonDecode(response.body);
    if (statusCode == 200) {
      Get.dialog(WaveDialog(
        titleText: 'Success',
        messageText: responseBody['message'],
        actionsWidget: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: Text('OK'),
          )
        ],
      ));
    }
  }
}
