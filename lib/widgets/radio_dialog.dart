import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectfm/app/modules/root/app_controller.dart';
import 'package:tapped/tapped.dart';
import 'package:waveui/waveui.dart';

class RadioDialog extends StatelessWidget {
  RadioDialog({super.key});

  final AppController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kBottomNavigationBarHeight + 10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          children: [
            Spacer(),
            Container(
              width: 300,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.grey.shade300,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(8),
              child: ListView.separated(
                itemCount: controller.radioList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var fm = controller.radioList[index];
                  return Tapped(
                    onTap: () {
                      if (controller.assetsAudioPlayer.isPlaying.value &&
                          controller.currentFMIndex.value == index) {
                        controller.isPlaying.value = false;
                        controller.assetsAudioPlayer.pause();
                        Get.back();
                      } else {
                        Get.back();
                        playRadio(controller, index);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Get.theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 35,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text(
                            fm.name ?? 'Unavailable',
                            style: Get.textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                          Spacer(),
                          Obx(
                            () => Icon(
                              controller.currentFMIndex.value == index &&
                                      controller.isPlaying.value
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 6);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> playRadio(AppController controller, int index) async {
  controller.isPlaying.value = true;
  controller.currentFMIndex.value = index;
  try {
    await controller.assetsAudioPlayer.open(
      Audio.liveStream('${controller.radioList[index].url}',
          metas: Metas(title: '${controller.radioList[index].name}')),
      autoStart: true,
      showNotification: true,
      notificationSettings: NotificationSettings(
        seekBarEnabled: false,
        nextEnabled: false,
        prevEnabled: false,
        customPlayPauseAction: (player) {
          if (player.isPlaying.value) {
            player.pause();
          } else {
            player.play();
          }
          controller.isPlaying.value = !player.isPlaying.value;
        },
      ),
    );
  } catch (t) {
    print(t);
  }
}
