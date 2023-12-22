import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectfm/app/modules/root/root_page.dart';
import 'root/app_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final AppController controller = Get.put(AppController(), permanent: true);
  @override
  void initState() {
    syncData();
    super.initState();
  }

  syncData() async {
    await controller.autoLogin();

    await controller.fetchRadioList();
    Get.offAll(() => RootPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      backgroundColor: Get.theme.cardColor,
      body: Center(
        child: Image.asset(
          'assets/ic_connectfm_logo.png',
          width: 120,
        ),
      ),
    );
  }
}
