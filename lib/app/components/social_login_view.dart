import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import '../modules/root/app_controller.dart';

class SocialLoginView extends StatelessWidget {
  SocialLoginView({super.key, this.isDoubleBack = false});
  final bool isDoubleBack;

  final AppController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialLoginButton(
          buttonType: SocialLoginButtonType.google,
          height: 45,
          onPressed: () {
            controller.signInwithGoogle();
          },
        ),
        SizedBox(height: 8),
        SocialLoginButton(
          height: 45,
          buttonType: SocialLoginButtonType.facebook,
          onPressed: () {
            controller.signInWithFacebook();
          },
        ),
        if (Platform.isIOS) ...[
          SizedBox(height: 8),
          SocialLoginButton(
            height: 45,
            buttonType: SocialLoginButtonType.appleBlack,
            onPressed: () {
              controller.signInWithApple();
            },
          ),
        ],
      ],
    );
  }
}
