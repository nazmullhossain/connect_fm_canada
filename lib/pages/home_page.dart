import 'dart:convert';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:connectfm/app/modules/root/app_controller.dart';
import 'package:connectfm/models/title_model.dart';
import 'package:connectfm/widgets/gradient_text.dart';
import 'package:connectfm/widgets/news_card.dart';
import 'package:waveui/waveui.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> navKey;
  HomePage({super.key, required this.navKey});

  @override
  State<HomePage> createState() => _HomePageState();
}
//ui change
class _HomePageState extends State<HomePage> {
  final AppController controller = Get.find();

  List<TitleModel> news = [];
  List<TitleModel> entertainment = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
//fetch data
  Future<List<TitleModel>> fetchData() async {
    if (news.isEmpty) {
      final response =
          await http.get(Uri.parse('https://cms.connectfm.ca//api/home'));
      if (response.statusCode == 200) {
        var list = jsonDecode(response.body)['sections'][0]['items'] as List;
        list.forEach((element) {
          news.add(TitleModel.fromJson(element));
        });
        return news;
      } else {
        throw Exception('Failed to load data');
      }
    }
    return news;
  }

  Future<List<TitleModel>> fetchEntertainment() async {
    if (entertainment.isEmpty) {
      final response = await http
          .get(Uri.parse('https://cms.connectfm.ca//api/entertainments'));
      if (response.statusCode == 200) {
        var list = jsonDecode(response.body)['entertainment'] as List;
        list.forEach((element) {
          entertainment.add(TitleModel.fromJson(element));
        });
        return entertainment;
      } else {
        throw Exception('Failed to load data');
      }
    }
    return entertainment;
  }

  @override
  Widget build(BuildContext context) {
    controller.updateLocation(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => widget.navKey.currentState!.openDrawer(),
          icon: Icon(FluentIcons.navigation_24_filled),
        ),
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/icon/icon.png',
          height: 65,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 46),
                  GradientText(text: "Latest News", showLangSwitcher: true),
                  Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                  FutureBuilder<List<TitleModel>>(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: news.length > 9 ? 9 : news.length,
                          itemBuilder: (context, index) => NewsCard(
                            titleModel: news[index],
                            isCompact: index != 0,
                            isEntertainments: false,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                            width: double.infinity,
                            height: 300,
                            child: Center(child: Text("${snapshot.error}")));
                      }
                      return Container(
                        width: double.infinity,
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                  GradientText(text: "Entertainment"),
                  Divider(
                    indent: 16,
                    endIndent: 16,
                  ),
                  FutureBuilder<List<TitleModel>>(
                    future: fetchEntertainment(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: entertainment.length > 9
                              ? 9
                              : entertainment.length,
                          itemBuilder: (context, index) => NewsCard(
                            titleModel: entertainment[index],
                            isCompact: index != 0,
                            isEntertainments: true,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                            width: double.infinity,
                            height: 300,
                            child: Center(child: Text("${snapshot.error}")));
                      }
                      return Container(
                        width: double.infinity,
                        height: 300,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            child: SimpleShadow(
              opacity: 0.1,
              child: Image.asset('assets/white_bg.png'),
            ),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}
