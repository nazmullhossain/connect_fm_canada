import 'package:waveui/waveui.dart';

class OpenMicPage extends StatelessWidget {
  OpenMicPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(title: 'Open mic'),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            repeat: ImageRepeat.repeat,
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/bg_gradient2.png',
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                "Record a message and we may play your voice On Air! Don't forget to tell us your name and where are you from!",
                style: Get.textTheme.bodyLarge!.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
