import 'package:connectfm/app/components/web_view.dart';

import '../../../utils/constant.dart';
import 'package:waveui/waveui.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(title: 'Legal'),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Get.to(WebviewPage(
                  title: 'Terms of use', link: Constant.termsOfUse));
            },
            title: Text('Terms of use'),
            trailing: Icon(FluentIcons.chevron_right_16_regular),
          ),
          WaveLine(),
          ListTile(
            onTap: () {
              Get.to(WebviewPage(
                  title: 'Privacy policy', link: Constant.privacyPolicy));
            },
            title: Text('Privacy policy'),
            trailing: Icon(FluentIcons.chevron_right_16_regular),
          ),
          WaveLine(),
        ],
      ),
    );
  }
}
