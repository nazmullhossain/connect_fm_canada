class TitleModel {
  int? id;
  List<String>? locale;
  String? slug;
  String? titlePa;
  String? introPa;
  List<String>? categories;
  String? postDate;
  String? postDateUpdated;
  String? image;
  bool? isUpdated;
  String? title;
  String? intro;

  TitleModel(
      {this.id,
      this.locale,
      this.slug,
      this.titlePa,
      this.introPa,
      this.categories,
      this.postDate,
      this.postDateUpdated,
      this.image,
      this.isUpdated,
      this.title,
      this.intro});

  TitleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    locale = json['locale'].cast<String>();
    slug = json['slug'];
    titlePa = json['titlePa'];
    introPa = json['introPa'];
    categories = json['categories'].cast<String>();
    postDate = json['postDate'];
    postDateUpdated = json['postDateUpdated'];
    image = json['image'];
    isUpdated = json['isUpdated'];
    title = json['title'];
    intro = json['intro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['locale'] = this.locale;
    data['slug'] = this.slug;
    data['titlePa'] = this.titlePa;
    data['introPa'] = this.introPa;
    data['categories'] = this.categories;
    data['postDate'] = this.postDate;
    data['postDateUpdated'] = this.postDateUpdated;
    data['image'] = this.image;
    data['isUpdated'] = this.isUpdated;
    data['title'] = this.title;
    data['intro'] = this.intro;
    return data;
  }
}
