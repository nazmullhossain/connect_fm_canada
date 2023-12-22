import 'package:connectfm/app/modules/root/app_controller.dart';
import 'package:waveui/waveui.dart';

class GradientText extends StatelessWidget {
  final String text;
  final bool showLangSwitcher;
  GradientText({super.key, required this.text, this.showLangSwitcher = false});

  final AppController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFF9025A), Color(0xFF081B70)],
            ).createShader(bounds),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Spacer(),
        if (showLangSwitcher)
          GestureDetector(
            onTap: () {
              controller.lang.value == 0
                  ? controller.lang.value = 1
                  : controller.lang.value = 0;
            },
            child: ElevatedButton(
              onPressed: () {
                controller.lang.value == 0
                    ? controller.lang.value = 1
                    : controller.lang.value = 0;
              },
              child: Obx(
                () => Text(controller.lang.value == 0
                    ? "ਪੰਜਾਬੀ ਵਿੱਚ ਪੜ੍ਹੋ"
                    : "READ IN ENGLISH"),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xFFFCBE6B)),
                foregroundColor: MaterialStatePropertyAll(Colors.black),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ),
        SizedBox(width: 16),
      ],
    );
  }
}
