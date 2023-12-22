class BuyAdsModel {
  String? customerName;
  String? companyName;
  String? advertisingBudget;
  String? email;
  String? phoneNumber;
  String? stationId;
  String? website;
  String? userComments;

  BuyAdsModel(
      {this.customerName,
      this.companyName,
      this.advertisingBudget,
      this.email,
      this.phoneNumber,
      this.stationId,
      this.website,
      this.userComments});

  BuyAdsModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    companyName = json['companyName'];
    advertisingBudget = json['advertisingBudget'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    stationId = json['stationId'];
    website = json['website'];
    userComments = json['userComments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['companyName'] = this.companyName;
    data['advertisingBudget'] = this.advertisingBudget;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['stationId'] = this.stationId;
    data['website'] = this.website;
    data['userComments'] = this.userComments;
    return data;
  }
}
