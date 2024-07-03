import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:connectfm/app/modules/root/app_controller.dart';
import 'package:connectfm/controllers/news_reader_controller.dart';
import 'package:waveui/waveui.dart';
import 'package:intl/date_symbol_data_local.dart';

class NewsReaderPage extends StatefulWidget {
  final String slug;
  final bool isEntertainments;
  const NewsReaderPage(
      {super.key, required this.slug, required this.isEntertainments});

  @override
  State<NewsReaderPage> createState() => _NewsReaderPageState();
}

class _NewsReaderPageState extends State<NewsReaderPage> {
  var newsController = NewsReaderController();
  final AppController controller = Get.find();

  @override
  void initState() {
    super.initState();
    newsController.getNews(widget.slug, widget.isEntertainments);
  }
//newscontroller
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WaveScaffold(
        appBar: WaveAppBar(
            title: widget.isEntertainments ? "Entertainment" : "News"),
        body: newsController.news.value.slug == null
            ? Center(
                child: SizedBox(
                  height: 35,
                  width: 35,
                  child: CircularProgressIndicator(),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.lang.value == 0
                                ? "${newsController.news.value.title}"
                                : "${newsController.news.value.titlePa}",
                            style: Get.textTheme.headlineMedium,
                          ),
                          //
                          SizedBox(height: 8),
                          Text(
                            "By ${newsController.news.value.author}, ${formatTimestamp(newsController.news.value.postDate)}",
                            style: Get.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          if ((newsController.news.value.images ?? []).length >
                              0)
                            AspectRatio(
                              aspectRatio: 5 / 3,
                              child: CachedNetworkImage(
                                imageUrl: newsController
                                    .news.value.images!.first.url!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          SizedBox(height: 8),
                          Html(
                            data: controller.lang.value == 0
                                ? "${newsController.news.value.body}"
                                : "${newsController.news.value.bodyPa}",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );
    });
  }

  String formatTimestamp(String? timestamp) {
    if (timestamp == null) {
      return 'Just now';
    } else {
      DateTime dateTime = DateTime.parse(timestamp).toUtc();
      initializeDateFormatting();
      var canadianLocale = 'en_CA'; 
      var timeZoneName = 'America/Toronto'; 
      var now = DateTime.now();
      var offset = now.timeZoneOffset;
      var daylightSavings = now.timeZoneName.contains('DST') ? 1 : 0;
      var timeZoneOffset = offset.inHours + daylightSavings;
      dateTime = dateTime.add(Duration(hours: timeZoneOffset));
      String formattedDate =
          DateFormat('MMM d, y h:mm a', canadianLocale).format(dateTime);
      return formattedDate;
    }
  }
}
