class RegisterModel {
  bool? success;
  String? token;
  String? firstName;
  String? mobile;
  String? email;
  String? age;
  String? gender;
  String? name;
  String? password;

  RegisterModel({
    this.success,
    this.token,
    this.firstName,
    this.mobile,
    this.email,
    this.age,
    this.name,
    this.password,
    this.gender,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    token = json['token'];
    firstName = json['first_name'];
    mobile = json['mobile'];
    email = json['email'];
    age = json['age'];
    name = json['name'];
    password = json['password'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['token'] = this.token;
    data['first_name'] = this.firstName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['age'] = this.age;
    data['name'] = this.name;
    data['password'] = this.password;
    data['gender'] = this.gender;
    return data;
  }
}
