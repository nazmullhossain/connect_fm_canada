import 'package:connectfm/models/title_model.dart';

class NewsModel {
  int? id;
  String? slug;
  String? title;
  String? titlePa;
  String? body;
  String? author;
  String? authorPa;
  String? bodyPa;
  String? postDate;
  List<Images>? images;
  bool? isUpdated;
  List<TitleModel>? related;
  List<TitleModel>? latest;

  NewsModel(
      {this.id,
      this.slug,
      this.title,
      this.titlePa,
      this.body,
      this.author,
      this.authorPa,
      this.bodyPa,
      this.postDate,
      this.images,
      this.isUpdated,
      this.related,
      this.latest});

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slug = json['slug'];
    title = json['title'];
    titlePa = json['titlePa'];
    body = json['body'];
    author = json['author'];
    authorPa = json['authorPa'];
    bodyPa = json['bodyPa'];
    postDate = json['postDate'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    isUpdated = json['isUpdated'];
    if (json['related'] != null) {
      related = <TitleModel>[];
      json['related'].forEach((v) {
        related!.add(new TitleModel.fromJson(v));
      });
    }
    if (json['latest'] != null) {
      latest = <TitleModel>[];
      json['latest'].forEach((v) {
        latest!.add(new TitleModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['slug'] = this.slug;
    data['title'] = this.title;
    data['titlePa'] = this.titlePa;
    data['body'] = this.body;
    data['author'] = this.author;
    data['authorPa'] = this.authorPa;
    data['bodyPa'] = this.bodyPa;
    data['postDate'] = this.postDate;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['isUpdated'] = this.isUpdated;
    if (this.related != null) {
      data['related'] = this.related!.map((v) => v.toJson()).toList();
    }
    if (this.latest != null) {
      data['latest'] = this.latest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? url;
  String? caption;
  String? captionPa;

  Images({this.url, this.caption, this.captionPa});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    caption = json['caption'];
    captionPa = json['captionPa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['caption'] = this.caption;
    data['captionPa'] = this.captionPa;
    return data;
  }
}
