class SongReqModel {
  String? customerName;
  String? email;
  String? phoneNumber;
  String? stationId;
  String? gender;
  String? song;
  String? album;
  String? artist;
  String? message;

  SongReqModel(
      {this.customerName,
      this.email,
      this.phoneNumber,
      this.stationId,
      this.gender,
      this.song,
      this.album,
      this.artist,
      this.message});

  SongReqModel.fromJson(Map<String, dynamic> json) {
    customerName = json['customerName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    stationId = json['stationId'];
    gender = json['gender'];
    song = json['song'];
    album = json['album'];
    artist = json['artist'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerName'] = this.customerName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['stationId'] = this.stationId;
    data['gender'] = this.gender;
    data['song'] = this.song;
    data['album'] = this.album;
    data['artist'] = this.artist;
    data['message'] = this.message;
    return data;
  }
}
