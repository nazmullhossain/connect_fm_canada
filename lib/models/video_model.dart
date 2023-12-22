class YoutubeModel {
  YoutubeModel({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
  });
  late final String kind;
  late final String etag;
  late final Id id;
  late final Snippet snippet;

  YoutubeModel.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    etag = json['etag'];
    id = Id.fromJson(json['id']);
    snippet = Snippet.fromJson(json['snippet']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['kind'] = kind;
    data['etag'] = etag;
    data['id'] = id.toJson();
    data['snippet'] = snippet.toJson();
    return data;
  }
}

class Id {
  Id({
    required this.kind,
    required this.videoId,
  });
  late final String kind;
  late final String videoId;

  Id.fromJson(Map<String, dynamic> json) {
    kind = json['kind'];
    videoId = json['videoId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['kind'] = kind;
    data['videoId'] = videoId;
    return data;
  }
}

class Snippet {
  Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.liveBroadcastContent,
    required this.publishTime,
  });
  late final String publishedAt;
  late final String channelId;
  late final String title;
  late final String description;
  late final Thumbnails thumbnails;
  late final String channelTitle;
  late final String liveBroadcastContent;
  late final String publishTime;

  Snippet.fromJson(Map<String, dynamic> json) {
    publishedAt = json['publishedAt'];
    channelId = json['channelId'];
    title = json['title'];
    description = json['description'];
    thumbnails = Thumbnails.fromJson(json['thumbnails']);
    channelTitle = json['channelTitle'];
    liveBroadcastContent = json['liveBroadcastContent'];
    publishTime = json['publishTime'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['publishedAt'] = publishedAt;
    data['channelId'] = channelId;
    data['title'] = title;
    data['description'] = description;
    data['thumbnails'] = thumbnails.toJson();
    data['channelTitle'] = channelTitle;
    data['liveBroadcastContent'] = liveBroadcastContent;
    data['publishTime'] = publishTime;
    return data;
  }
}

class Thumbnails {
  Thumbnails({
    required this.defaultmodel,
    required this.medium,
    required this.high,
  });
  late final DefaultModel defaultmodel;
  late final Medium medium;
  late final High high;

  Thumbnails.fromJson(Map<String, dynamic> json) {
    defaultmodel = DefaultModel.fromJson(json['default']);
    medium = Medium.fromJson(json['medium']);
    high = High.fromJson(json['high']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['default'] = defaultmodel.toJson();
    data['medium'] = medium.toJson();
    data['high'] = high.toJson();
    return data;
  }
}

class DefaultModel {
  DefaultModel({
    required this.url,
    required this.width,
    required this.height,
  });
  late final String url;
  late final int width;
  late final int height;

  DefaultModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class Medium {
  Medium({
    required this.url,
    required this.width,
    required this.height,
  });
  late final String url;
  late final int width;
  late final int height;

  Medium.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}

class High {
  High({
    required this.url,
    required this.width,
    required this.height,
  });
  late final String url;
  late final int width;
  late final int height;

  High.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['url'] = url;
    data['width'] = width;
    data['height'] = height;
    return data;
  }
}
