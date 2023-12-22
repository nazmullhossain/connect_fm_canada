import 'package:connectfm/app/components/social_login_view.dart';
import 'package:connectfm/app/data/models/register_model.dart';

import '../root/app_controller.dart';
import 'auth_controller.dart';
import 'package:waveui/waveui.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final AuthController controller = AuthController();
  final AppController _controller = Get.find();
  String? gender;
  bool isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      isBlurred: true,
      isLoading: isLoading,
      appBar: WaveAppBar(
        isBlurred: true,
        title: "Sign up",
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
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FluentIcons.person_28_regular,
                            color: Colors.grey,
                          ),
                          hintText: "NAME",
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.name,
                        controller: controller.nameEditingController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a username!';
                          } else if (value.length < 6) {
                            return "Please provide a username of 6 character";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch('$value')
                              ? null
                              : "Please Enter Correct Email";
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FluentIcons.mail_28_regular,
                            color: Colors.grey,
                          ),
                          hintText: "EMAIL",
                        ),
                        controller: controller.emailEditingController,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter a password!';
                          } else if (value.length < 4) {
                            return "Please provide password of 4 character ";
                          }
                          return null;
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
                        controller: controller.passwordEditingController,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (!GetUtils.isPhoneNumber(value.toString())) {
                            return "Please enter a valid phone number.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FluentIcons.phone_20_regular,
                            color: Colors.grey,
                          ),
                          hintText: "Mobile",
                        ),
                        controller: controller.mobileEditingController,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text("Select Gender"),
                      value: gender,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(8),
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      // Down Arrow Icon,
                      icon: const Icon(FluentIcons.chevron_down_16_regular),

                      // Array list of items

                      items: [
                        DropdownMenuItem(
                          child: Text('Male'),
                          value: "Male",
                        ),
                        DropdownMenuItem(
                          child: Text('Female'),
                          value: "Female",
                        ),
                        DropdownMenuItem(
                          child: Text('Others'),
                          value: "Others",
                        ),
                      ],
                      onChanged: (value) {
                        gender = value.toString();

                        setState(() {});
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                FilledButton(
                  child: Text("SIGN UP"),
                  onPressed: _formKey.currentState?.validate() ?? false
                      ? () {
                          if (_formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isLoading = true;
                            });
                            _controller
                                .createUser(
                                  RegisterModel(
                                    email:
                                        controller.emailEditingController.text,
                                    firstName:
                                        controller.nameEditingController.text,
                                    gender: gender,
                                    mobile:
                                        controller.mobileEditingController.text,
                                    password: controller
                                        .passwordEditingController.text,
                                    name: controller.nameEditingController.text,
                                  ),
                                )
                                .then((value) => setState(() {
                                      isLoading = value;
                                    }));
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
                      "Already a member? ",
                      style: TextStyle(
                        // color: Colors.grey.shade900,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "Sign in",
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
                Center(
                    child: SocialLoginView(
                  isDoubleBack: true,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
