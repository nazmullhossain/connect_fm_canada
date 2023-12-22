class FM {
  int? id;
  String? name;
  String? logo;
  String? url;

  FM({this.id, this.name, this.logo, this.url});

  FM.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    logo = json['logo'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['url'] = this.url;
    return data;
  }
}
