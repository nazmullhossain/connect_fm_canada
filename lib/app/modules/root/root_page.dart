import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectfm/pages/videos_page.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/share.dart';
import 'package:connectfm/app/modules/auth/login_page.dart';
import 'package:connectfm/app/modules/song_request_page.dart';
import 'package:connectfm/pages/contact_us_page.dart';
import 'package:connectfm/pages/entertainment_page.dart';
import 'package:connectfm/pages/home_page.dart';
import 'package:connectfm/pages/news_page.dart';
import 'package:connectfm/pages/privacy_policy_page.dart';
import 'package:connectfm/pages/sales_and_ads_page.dart';
import 'package:connectfm/pages/tnc_page.dart';
import 'package:connectfm/pages/user_details_page.dart';
import 'package:connectfm/widgets/radio_dialog.dart';
import 'package:tapped/tapped.dart';
import '../feedback_page.dart';
import 'app_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waveui/waveui.dart';

class RootPage extends StatefulWidget {
  RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final AppController controller = Get.find();

  final CarouselController carouselController1 = CarouselController();

  final CarouselController carouselController0 = CarouselController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<PackageInfo> packageInfo = PackageInfo.fromPlatform();
  String? version;
  String? androidAddress;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Get.theme.colorScheme.primary,
      ),
    );
    packageInfo.then((value) {
      version = value.version;
      androidAddress = value.packageName;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Obx(
        () => Scaffold(
          key: _scaffoldKey,
          floatingActionButton: controller.isPlaying.value
              ? FloatingActionButton(
                  elevation: 0,
                  backgroundColor: Colors.grey.shade900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  onPressed: () {
                    if (controller.isMute.value) {
                      controller.isMute.value = false;
                      controller.assetsAudioPlayer.setVolume(1);
                    } else {
                      controller.isMute.value = true;
                      controller.assetsAudioPlayer.setVolume(0);
                    }
                  },
                  child: Icon(
                    controller.isMute.value
                        ? FluentIcons.speaker_mute_28_regular
                        : FluentIcons.speaker_2_28_regular,
                  ),
                )
              : null,
          drawer: Drawer(
            child: Scaffold(
              backgroundColor: Get.theme.cardColor,
              appBar: WaveAppBar(title: "Settings"),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    if (controller.isLoggedIn())
                      ListTile(
                        leading: Icon(
                          FluentIcons.person_28_regular,
                        ),
                        onTap: () {
                          Get.back();
                          Get.to(() => UserDetailsPage(
                              user: controller.userModel.value!));
                        },
                        title: Text('Profile'),
                        trailing: Icon(FluentIcons.chevron_right_16_regular),
                      ),
                    if (!controller.isLoggedIn())
                      ListTile(
                        leading: Icon(
                          FluentIcons.arrow_enter_20_regular,
                        ),
                        onTap: () {
                          Get.back();
                          Get.to(() => LoginPage());
                        },
                        title: Text('Login'),
                        trailing: Icon(FluentIcons.chevron_right_16_regular),
                      ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.news_28_regular,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => NewsPage());
                      },
                      title: Text('News'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.music_note_2_24_regular,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => EntertainmentPage());
                      },
                      title: Text('Entertainment'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.headphones_sound_wave_28_regular,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => SongReqPage());
                      },
                      title: Text('Song Request'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    // TODO:
                    // ListTile(
                    //   leading: Icon(
                    //     FluentIcons.speaker_0_28_regular,
                    //   ),
                    //   onTap: () {
                    //     Get.back();
                    //     Get.to(() => BuyAdsPage(
                    //         fmIndex: controller
                    //                 .radioList[controller.currentFMIndex.value]
                    //                 .id ??
                    //             0));
                    //   },
                    //   title: Text('Buy Ads'),
                    //   trailing: Icon(FluentIcons.chevron_right_16_regular),
                    // ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.person_feedback_28_regular,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => FeedbackPage());
                      },
                      title: Text('Feedback'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.speaker_0_28_regular,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => SalesAndAdsPage());
                      },
                      title: Text('Sales and Advertising'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.star_28_regular,
                      ),
                      onTap: () async {
                        Get.back();

                        await packageInfo.then((value) {
                          launchUrl(
                              Uri.parse(Platform.isAndroid
                                  ? "https://play.google.com/store/apps/details?id=" +
                                      value.packageName
                                  : "https://apps.apple.com/us/app/connect-fm-canada/id6468108918"),
                              mode: LaunchMode.externalApplication);
                        });
                      },
                      title: Text('Rate the app'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.contact_card_28_regular,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => ContactUsPage());
                      },
                      title: Text('Contact Us'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.share_28_regular,
                      ),
                      onTap: () async {
                        Get.back();

                        await packageInfo.then((value) {
                          Share.share(
                              """Now you can hear the best of traditional music where ever you are! Just download the new Connect FM apps here.
        
        www.connectfm.ca/apps
        https://play.google.com/store/apps/details?id=""" +
                                  value.packageName);
                        });
                      },
                      title: Text('Share'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(
                        FluentIcons.warning_28_regular,
                      ),
                      onTap: () {
                        Get.back();
                        Get.to(() => TncPage());
                      },
                      title: Text('Terms of Use'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    ListTile(
                      leading: Icon(FluentIcons.lock_closed_28_regular),
                      onTap: () {
                        Get.back();
                        Get.to(() => PrivacyPolicyPage());
                      },
                      title: Text('Privacy Policy'),
                      trailing: Icon(FluentIcons.chevron_right_16_regular),
                    ),
                    if (controller.isLoggedIn())
                      ListTile(
                        onTap: () {
                          controller.logout();
                        },
                        title: Text('Logout'),
                      ),
                    Divider(),
                    ListTile(
                      title: Text('$version'),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: _bottomNav(),
          body: Obx(
            () => LazyLoadIndexedStack(
              children: <Widget>[
                SafeArea(child: HomePage(navKey: _scaffoldKey)),
                // SafeArea(
                //     child: WebviewPlainPage(
                //         link: 'https://m.youtube.com/connectfmcanada')),
                VideoListScreen(),
              ],
              index: controller.currentNavIndex.value,
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomIcon({
    required IconData icon,
    required String title,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return Expanded(
      child: Tapped(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.white,
                size: 30,
              ),
              SizedBox(height: 2),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      padding: Platform.isIOS ? EdgeInsets.only(bottom: 24) : EdgeInsets.zero,
      width: double.infinity,
      color: Get.theme.colorScheme.primary,
      child: Row(
        children: [
          _bottomIcon(
            icon: FluentIcons.home_32_regular,
            title: "HOME",
            isSelected: controller.currentNavIndex.value == 0,
            onTap: () => controller.currentNavIndex.value = 0,
          ),
          _bottomIcon(
            icon: FluentIcons.headphones_sound_wave_28_regular,
            title: "REQUEST",
            onTap: () => Get.to(() => SongReqPage()),
          ),
          _bottomIcon(
            icon: Icons.radio_outlined,
            title: controller.radioList.length > 0
                ? controller.isPlaying.value
                    ? "${controller.radioList[controller.currentFMIndex.value].name}"
                    : "LIVE RADIO"
                : "LIVE RADIO",
            onTap: () => Get.dialog(
              RadioDialog(),
              barrierColor: Colors.transparent,
            ),
          ),
          _bottomIcon(
            icon: FluentIcons.play_circle_28_regular,
            title: "VIDEO",
            isSelected: controller.currentNavIndex.value == 1,
            onTap: () => controller.currentNavIndex.value = 1,
          ),
          _bottomIcon(
            icon: FluentIcons.add_28_regular,
            title: "MORE",
            onTap: () => _scaffoldKey.currentState!.openDrawer(),
          ),
        ],
      ),
    );
  }

  Future<void> playRadio(int index) async {
    controller.isPlaying.value = true;

    await controller.assetsAudioPlayer.open(
      Audio.liveStream('${controller.radioList[index].url}',
          metas: Metas(title: '${controller.radioList[index].name}')),
      autoStart: true,
      showNotification: true,
      notificationSettings: NotificationSettings(
        seekBarEnabled: false,
        nextEnabled: false,
        playPauseEnabled: true,
        prevEnabled: false,
        customPlayPauseAction: (player) async {
          if (!controller.isPlaying.value) {
            controller.isPlaying.value = true;
          }
          player.play();
        },
        customStopAction: (player) {
          controller.isPlaying.value = false;
          player.pause();
        },
      ),
    );
  }
}
