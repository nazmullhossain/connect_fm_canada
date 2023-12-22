import 'package:connectfm/app/data/models/buy_ads_model.dart';

import 'root/app_controller.dart';
import 'package:waveui/waveui.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BuyAdsPage extends StatefulWidget {
  BuyAdsPage({super.key, required this.fmIndex});

  final int fmIndex;

  @override
  State<BuyAdsPage> createState() => _BuyAdsPageState();
}

class _BuyAdsPageState extends State<BuyAdsPage> {
  bool isValidButton = false;

  String? nameError;
  String? phnError;
  String? emailError;
  String? businessError;
  String? budgetError;
  int radioIndex = 1;

  final AppController controller = Get.find();
  @override
  void initState() {
    if (controller.isLoggedIn()) {
      nameted.text = controller.auth.currentUser?.displayName ??
          controller.userModel.value?.firstName ??
          "";
      emailted.text = controller.auth.currentUser?.email ??
          controller.userModel.value?.email ??
          "";
      phoneted.text = controller.auth.currentUser?.phoneNumber ??
          controller.userModel.value?.mobile ??
          "";
    }
    radioIndex = controller.currentFMIndex.value + 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      resizeToAvoidBottomInset: true,
      appBar: WaveAppBar(title: "Buy Ads"),
      backgroundColor: Get.theme.cardColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              Text(
                'Advertise on Connect FM fastest growing radio station',
                style: Get.textTheme.titleSmall,
              ),
              SizedBox(
                height: 6,
              ),
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
              SizedBox(
                height: 6,
              ),
              WaveInputText(
                backgroundColor: Colors.transparent,
                hint: 'Name*',
                isEnabled: !controller.isLoggedIn(),
                textEditingController: nameted,
                errorText: nameError,
                onTextChange: (input) {
                  isValid();
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
                hint: 'Phone Number*',
                textEditingController: phoneted,
                errorText: phnError,
                isEnabled: !controller.isLoggedIn(),
                onTextChange: (input) {
                  isValid();
                  if (!GetUtils.isPhoneNumber(input)) {
                    setState(() {
                      phnError = "Please type your valid phone number";
                    });
                  } else {
                    setState(() {
                      phnError = null;
                    });
                  }
                },
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                backgroundColor: Colors.transparent,
                hint: 'Email Address*',
                isEnabled: !controller.isLoggedIn(),
                textEditingController: emailted,
                errorText: emailError,
                onTextChange: (input) {
                  isValid();
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
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                backgroundColor: Colors.transparent,
                hint: 'Business name*',
                textEditingController: businessted,
                errorText: businessError,
                onTextChange: (input) {
                  isValid();
                  if (input.isEmpty) {
                    setState(() {
                      businessError = "Enter a valid business name";
                    });
                  } else {
                    setState(() {
                      businessError = null;
                    });
                  }
                },
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                backgroundColor: Colors.transparent,
                hint: 'Website',
                textEditingController: websiteted,
                onTextChange: (input) {
                  isValid();
                },
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                backgroundColor: Colors.transparent,
                hint: 'Budget(Minimum 2000\$ per month) *',
                textEditingController: budgetted,
                keyboardType: TextInputType.number,
                errorText: budgetError,
                onTextChange: (input) {
                  isValid();
                  if (input.isEmpty) {
                    setState(() {
                      budgetError = "Enter a valid budget";
                    });
                  } else {
                    setState(() {
                      budgetError = null;
                    });
                  }
                },
              ),
              SizedBox(
                height: 12,
              ),
              WaveInputText(
                backgroundColor: Colors.transparent,
                hint: 'Your comment',
                textEditingController: cmntted,
                minLines: 5,
                keyboardType: TextInputType.multiline,
                onTextChange: (input) {
                  isValid();
                },
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      child: Text("Submit"),
                      onPressed: !isValidButton
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return WavePageLoading();
                                },
                              );
                              makePostRequest();
                            },
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

  TextEditingController phoneted = TextEditingController();

  TextEditingController nameted = TextEditingController();

  TextEditingController emailted = TextEditingController();

  TextEditingController businessted = TextEditingController();

  TextEditingController websiteted = TextEditingController();

  TextEditingController budgetted = TextEditingController();

  TextEditingController cmntted = TextEditingController();

  isValid() {
    if (budgetted.text.isNotEmpty) {
      if (nameted.text.isNotEmpty) {
        if (GetUtils.isPhoneNumber(phoneted.text)) {
          if (GetUtils.isEmail(emailted.text)) {
            if (businessted.text.isNotEmpty) {
              setState(() {
                isValidButton = true;
              });
            } else {
              setState(() {
                isValidButton = false;
              });
            }
          } else {
            setState(() {
              isValidButton = false;
            });
          }
        } else {
          setState(() {
            isValidButton = false;
          });
        }
      } else {
        setState(() {
          isValidButton = false;
        });
      }
    } else {
      setState(() {
        isValidButton = false;
      });
    }
  }

  makePostRequest() async {
    final uri = Uri.parse(
        'http://stagingapp.connectfm.ca/connectfm-api/public/api/createAdvertiserLeads');
    final headers = {'Content-Type': 'application/json'};
    final encoding = Encoding.getByName('utf-8');

    http.Response response = await http
        .post(
          uri,
          headers: headers,
          body: jsonEncode(BuyAdsModel(
            advertisingBudget: budgetted.text,
            companyName: businessted.text,
            customerName: nameted.text,
            email: emailted.text,
            phoneNumber: phoneted.text,
            website: websiteted.text,
            userComments: cmntted.text,
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
