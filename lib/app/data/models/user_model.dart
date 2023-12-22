class UserModel {
  bool? success;
  String? token;
  String? firstName;
  String? mobile;
  String? email;
  String? age;
  String? zipcode;
  String? gender;
  String? subscription;

  UserModel(
      {this.success,
      this.token,
      this.firstName,
      this.mobile,
      this.email,
      this.age,
      this.zipcode,
      this.gender,
      this.subscription});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    firstName = json['first_name'];
    mobile = json['mobile'];
    email = json['email'];
    age = json['age'];
    zipcode = json['zipcode'];
    gender = json['gender'];
    subscription = json['subscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['token'] = this.token;
    data['first_name'] = this.firstName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['age'] = this.age;
    data['zipcode'] = this.zipcode;
    data['gender'] = this.gender;
    data['subscription'] = this.subscription;
    return data;
  }
}
