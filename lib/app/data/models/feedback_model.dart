class FeedbackModel {
  String? customerName;
  String? email;
  String? phoneNumber;
  String? stationId;
  String? message;
  String? gender;

  FeedbackModel(
      {this.customerName,
      this.email,
      this.phoneNumber,
      this.stationId,
      this.message,
      this.gender});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    stationId = json['stationId'];
    message = json['message'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['stationId'] = this.stationId;
    data['message'] = this.message;
    data['gender'] = this.gender;
    return data;
  }
}
