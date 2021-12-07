class ReportModel {
  int reportId;
  String address;
  String lat;
  String lang;
  String city;
  String province;
  String thumbnail;
  String username;
  String userId;

  ReportModel(
      {required this.address,
      required this.city,
      required this.lang,
      required this.lat,
      required this.province,
      required this.reportId,
      required this.thumbnail,
      required this.userId,
      required this.username});

  ReportModel.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        city = json['city'],
        province = json['province'],
        thumbnail = json['thumbnail'],
        userId = json['userId'],
        reportId = json['reportId'],
        lat = json['lat'],
        lang = json['lang'],
        username = json['user'];
}
