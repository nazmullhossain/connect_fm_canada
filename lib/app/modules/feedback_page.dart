import 'dart:convert';

import 'package:connectfm/app/data/models/feedback_model.dart';

import 'root/app_controller.dart';
import 'package:waveui/waveui.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final AppController controller = Get.find();

  final TextEditingController nameted = TextEditingController();

  final TextEditingController emailted = TextEditingController();

  final TextEditingController messageted = TextEditingController();

  bool isValid = false;
  bool isLoading = false;
  int radioIndex = 1;

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

  String? nameError;
  String? emailError;
  String? cmntError;

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      isLoading: isLoading,
      appBar: WaveAppBar(title: "Feedback"),
      backgroundColor: Get.theme.cardColor,
      body: isLoading
          ? WavePageLoading()
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: controller.radioList
                              .map((element) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
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
                    SizedBox(
                      height: 12,
                    ),
                    WaveInputText(
                      backgroundColor: Colors.transparent,
                      hint: "Name*",
                      textEditingController: nameted,
                      errorText: nameError,
                      isEnabled: !controller.isLoggedIn(),
                      onTextChange: (input) {
                        _isValid();
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
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    WaveInputText(
                      backgroundColor: Colors.transparent,
                      hint: "Email*",
                      errorText: emailError,
                      isEnabled: !controller.isLoggedIn(),
                      textEditingController: emailted,
                      onTextChange: (input) {
                        _isValid();
                        if (!input.isEmail) {
                          setState(() {
                            emailError = "Please type your valid email";
                          });
                        } else {
                          setState(() {
                            emailError = null;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    WaveInputText(
                      backgroundColor: Colors.transparent,
                      hint: "Message*",
                      textEditingController: messageted,
                      minLines: 5,
                      errorText: cmntError,
                      onTextChange: (input) {
                        _isValid();
                        if (input.isEmpty) {
                          setState(() {
                            cmntError = "Write your feedback";
                          });
                        } else {
                          setState(() {
                            cmntError = null;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text("Submit"),
                            onPressed: isValid
                                ? () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await makePostRequest();

                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                : null,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  void _isValid() {
    if (nameted.text.isNotEmpty) {
      if (GetUtils.isEmail(emailted.text)) {
        if (messageted.text.isNotEmpty) {
          setState(() {
            isValid = true;
          });
        } else {
          setState(() {
            isValid = false;
          });
        }
      } else {
        setState(() {
          isValid = false;
        });
      }
    } else {
      setState(() {
        isValid = false;
      });
    }
  }

  makePostRequest() async {
    final uri = Uri.parse(
        'http://stagingapp.connectfm.ca/connectfm-api/public/api/createFeedback');
    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http
        .post(
          uri,
          headers: headers,
          body: jsonEncode(FeedbackModel(
            customerName: nameted.text,
            email: emailted.text,
            message: messageted.text,
            phoneNumber: controller.auth.currentUser?.phoneNumber ??
                controller.userModel.value?.mobile ??
                "",
            stationId: "$radioIndex",
            gender: controller.userModel.value?.gender ?? "",
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
