import 'package:get/get.dart';
import 'package:connectfm/models/title_model.dart';

class NewsController extends GetxController {
  var _client = GetConnect();
  var latestNews = <TitleModel>[].obs;
  var slug = 'latest'.obs;

  getLatestNews() async {
    latestNews.clear();

    var request = await _client
        .get('https://cms.connectfm.ca//api/news/${slug.value}/en_us?page=1');
    if (request.statusCode == 200) {
      (request.body['data'] as List).forEach((title) {
        latestNews.add(TitleModel.fromJson(title));
      });
    }
  }

  getMoreNews() async {
    var request = await _client.get(
        'https://cms.connectfm.ca//api/news/${slug.value}/en_us?page=${(latestNews.length / 9) + 1}');
    if (request.statusCode == 200) {
      (request.body['data'] as List).forEach((title) {
        latestNews.add(TitleModel.fromJson(title));
      });
    }
  }
}
