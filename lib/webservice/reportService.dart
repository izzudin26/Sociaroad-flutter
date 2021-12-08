import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as Http;
import './url.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:society_road/model/imagePickerModel.dart';
import 'package:society_road/model/reportModel.dart';

class ReportService {
  static Future<int> createReport(
      {required String lang,
      required String lat,
      required String city,
      required String province,
      required String address,
      required String description}) async {
    Map<String, dynamic> sendData = {
      'lang': lang,
      'lat': lat,
      'city': city,
      'province': province,
      'address': address,
      'description': description
    };

    String user = FirebaseAuth.instance.currentUser!.uid;
    final response = await Http.post(Uri.parse('$serverUrl/report'),
        body: jsonEncode(sendData),
        headers: {'Authorization': user, "content-type": "application/json"});
    if (response.statusCode == 201) {
      Map<String, dynamic> res = jsonDecode(response.body);
      return res['data']['raw']['insertId'];
    } else {
      Map<String, dynamic> res = jsonDecode(response.body);
      print(res);
      throw res['message'];
    }
  }

  static Future<ImagePickerModel> uploadImage(
      {required File image, required int reportId}) async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    Uri url = Uri.parse('$serverUrl/asset/upload/$reportId');
    Http.MultipartFile body =
        await Http.MultipartFile.fromPath("image", image.path);
    var request = Http.MultipartRequest("POST", url);
    request.headers["Authorization"] = user;
    request.files.add(body);
    final res = await request.send();
    final resData = await res.stream.toBytes();
    final resBody = String.fromCharCodes(resData);
    print(jsonDecode(resBody)['data']);
    if (res.statusCode == 200) {
      return ImagePickerModel.fromJson(jsonDecode(resBody)['data']);
    } else {
      throw jsonDecode(resBody)['message'];
    }
  }

  static Future<void> removeAssetImage({required int imageId}) async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    final req = await Http.delete(Uri.parse('$serverUrl/asset/$imageId'),
        headers: {'Authorization': user});
    if (req.statusCode != 200) {
      Map<String, dynamic> res = jsonDecode(req.body);
      throw res['message'];
    }
  }

  static Future<List<ReportModel>> getCollectionReport(
      {required String city, required int page}) async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    try {
      final req = await Http.get(
          Uri.parse('$serverUrl/report?page=$page&city=$city'),
          headers: {'Authorization': user});
      Map<String, dynamic> body = jsonDecode(req.body);
      List<ReportModel> data =
          (body['data'] as List).map((e) => ReportModel.fromJson(e)).toList();
      return data;
    } catch (e) {
      throw e;
    }
  }

  static Future<List<ReportModel>> getPersonReport() async {
    String user = FirebaseAuth.instance.currentUser!.uid;
    try {
      final req = await Http.get(
          Uri.parse('$serverUrl/report/collection/user'),
          headers: {'Authorization': user});
      Map<String, dynamic> body = jsonDecode(req.body);
      List<ReportModel> data =
          (body['data'] as List).map((e) => ReportModel.fromJson(e)).toList();
      return data;
    } catch (e) {
      throw e;
    }
  }
}
