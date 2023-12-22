import 'package:connectfm/controllers/news_controller.dart';
import 'package:connectfm/widgets/gradient_text.dart';
import 'package:connectfm/widgets/news_card.dart';
import 'package:tapped/tapped.dart';
import 'package:waveui/waveui.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsController _newsController = NewsController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _newsController.getLatestNews();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WaveAppBar(title: 'News'),
      body: Obx(() {
        return _newsController.latestNews.length > 0
            ? ListView.builder(
                itemCount: _newsController.latestNews.length + 2,
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
                              _tabs(title: 'All', slug: 'latest'),
                              SizedBox(width: 12),
                              _tabs(title: 'Alberta', slug: 'alberta'),
                              SizedBox(width: 12),
                              _tabs(title: 'BC', slug: 'bc'),
                              SizedBox(width: 12),
                              _tabs(title: 'Canada', slug: 'canada'),
                              SizedBox(width: 12),
                              _tabs(title: 'World', slug: 'world'),
                              SizedBox(width: 12),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        GradientText(text: "News", showLangSwitcher: true),
                      ],
                    );
                  }
                  if (index == _newsController.latestNews.length + 1) {
                    _newsController.getMoreNews();
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Column(children: [
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 35,
                          height: 35,
                        ),
                      ]),
                    );
                  }
                  return NewsCard(
                    titleModel: _newsController.latestNews[index - 1],
                    isCompact: index > 1,
                    isEntertainments: false,
                  );
                },
              )
            : LinearProgressIndicator(minHeight: 3);
      }),
    );
  }

  _tabs({
    required String title,
    required String slug,
  }) {
    return Tapped(
      onTap: () {
        _newsController.slug.value = slug;
        _newsController.getLatestNews();
      },
      child: Column(
        children: [
          Text(title, style: Get.textTheme.titleSmall),
          SizedBox(height: 4),
          Obx(
            () => _newsController.slug.value == slug
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
