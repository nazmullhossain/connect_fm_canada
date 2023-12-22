import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectfm/models/news_model.dart';

class NewsReaderController extends GetxController {
  var _client = GetConnect();
  var news = NewsModel().obs;

  getNews(String? slug, bool isEntertainments) async {
    var request = await _client.get(
        'https://cms.connectfm.ca//api/${isEntertainments ? 'entertainments' : 'news'}/post/$slug');
    debugPrint(request.request!.url.toString());
    if (request.statusCode == 200) {
      news.value = NewsModel.fromJson(request.body);
    }
  }
}
