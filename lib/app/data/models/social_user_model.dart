class SocialUserModel {
  String? name;
  String? mobile;
  String? email;
  String? gender;
  int? age;
  String? socialProfile;
  int? zipcode;
  String? country;
  String? city;

  SocialUserModel(
      {this.name,
      this.mobile,
      this.email,
      this.gender,
      this.age,
      this.socialProfile,
      this.zipcode,
      this.country,
      this.city});

  SocialUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    gender = json['gender'];
    age = json['age'];
    socialProfile = json['social_profile'];
    zipcode = json['zipcode'];
    country = json['country'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['social_profile'] = this.socialProfile;
    data['zipcode'] = this.zipcode;
    data['country'] = this.country;
    data['city'] = this.city;
    return data;
  }
}
