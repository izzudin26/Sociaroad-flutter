class ImagePickerModel {
  String locationPath;
  int? id;

  ImagePickerModel({this.id, required this.locationPath});

  Map<String, dynamic> toJson() => {"id": id, "locationPath": locationPath};

  ImagePickerModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        locationPath = json['locationPath'];
}
