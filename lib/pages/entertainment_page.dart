import 'dart:convert';
import 'package:connectfm/models/title_model.dart';
import 'package:connectfm/widgets/gradient_text.dart';
import 'package:connectfm/widgets/news_card.dart';
import 'package:tapped/tapped.dart';
import 'package:waveui/waveui.dart';
import 'package:http/http.dart' as http;

class EntertainmentPage extends StatefulWidget {
  const EntertainmentPage({super.key});

  @override
  State<EntertainmentPage> createState() => _EntertainmentPageState();
}

class _EntertainmentPageState extends State<EntertainmentPage> {
  List<TitleModel> all = [];
  List<TitleModel> bollywood = [];
  List<TitleModel> pollywood = [];

  var controller = EntertainmentController();

  fetchData() async {
    all.clear();
    bollywood.clear();
    pollywood.clear();
    final response = await http
        .get(Uri.parse('https://cms.connectfm.ca//api/entertainments'));
    print(response.body);
    if (response.statusCode == 200) {
      (jsonDecode(response.body)['entertainment'] as List).forEach((element) {
        all.add(TitleModel.fromJson(element));
      });
      (jsonDecode(response.body)['bollywood'] as List).forEach((element) {
        bollywood.add(TitleModel.fromJson(element));
      });
      (jsonDecode(response.body)['pollywood'] as List).forEach((element) {
        pollywood.add(TitleModel.fromJson(element));
      });
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WaveScaffold(
      appBar: WaveAppBar(title: 'Entertainment'),
      body: all.length > 0
          ? Obx(() {
              return ListView.builder(
                itemCount: (controller.index.value == 0
                        ? all.length
                        : controller.index.value == 1
                            ? bollywood.length
                            : pollywood.length) +
                    1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          color: Colors.white,
                          child: Row(
                            children: [
                              _tabs(title: 'All', index: 0),
                              SizedBox(width: 12),
                              _tabs(title: 'Bollywood', index: 1),
                              SizedBox(width: 12),
                              _tabs(title: 'Pollywood', index: 2),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        GradientText(
                            text: "Entertainment", showLangSwitcher: true),
                      ],
                    );
                  }

                  return NewsCard(
                    titleModel: (controller.index.value == 0
                        ? all
                        : controller.index.value == 1
                            ? bollywood
                            : pollywood)[index - 1],
                    isCompact: index > 1,
                    isEntertainments: true,
                  );
                },
              );
            })
          : LinearProgressIndicator(minHeight: 3),
    );
  }

  _tabs({
    required String title,
    required int index,
  }) {
    return Tapped(
      onTap: () {
        controller.index.value = index;
      },
      child: Column(
        children: [
          Text(title, style: Get.textTheme.titleSmall),
          SizedBox(height: 4),
          Obx(
            () => controller.index.value == index
                ? Container(
                    height: 2,
                    width: 40,
                    color: Get.theme.colorScheme.primary,
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class EntertainmentController extends GetxController {
  var index = 0.obs;
}
