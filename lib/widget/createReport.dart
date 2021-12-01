import 'dart:async';

import 'package:flutter/material.dart';
import 'package:society_road/widget/imageUploader.dart';
import 'package:society_road/webservice/reportService.dart';

class CreateReport extends StatefulWidget {
  String address;
  String city;
  String lang;
  String lat;
  String province;
  CreateReport(
      {Key? key,
      required this.lang,
      required this.lat,
      required this.city,
      required this.province,
      required this.address})
      : super(key: key);

  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  TextEditingController address = TextEditingController();
  TextEditingController lang = TextEditingController();
  TextEditingController lat = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController description = TextEditingController();

  bool isProcessing = false;
  bool isMountedComponent = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      setState(() {
        isMountedComponent = true;
        address.text = widget.address;
        lang.text = widget.lang;
        lat.text = widget.lat;
        city.text = widget.city;
        province.text = widget.province;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Buat Laporan", style: TextStyle(color: Colors.blue)),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () async {
                int store = await ReportService.createReport(
                    lang: lang.text,
                    lat: lat.text,
                    city: city.text,
                    province: province.text,
                    address: address.text,
                    description: description.text);
                setState(() {
                  isProcessing = !isProcessing;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageUploader(
                                reportId: store,
                              )));
                });
              },
              child:
                  Text("Upload Gambar", style: TextStyle(color: Colors.blue)))
        ],
        bottom: !isProcessing
            ? null
            : PreferredSize(
                child: LinearProgressIndicator(),
                preferredSize: Size.fromHeight(.5)),
      ),
      body: SingleChildScrollView(
        child: AnimatedSize(
          duration: Duration(milliseconds: 500),
          child: Container(
            height: isMountedComponent ? null : 0.0,
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                TextField(
                  controller: address,
                  decoration: InputDecoration(
                      label: Text("Alamat"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: city,
                  readOnly: true,
                  decoration: InputDecoration(
                      label: Text("Kota"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: province,
                  readOnly: true,
                  decoration: InputDecoration(
                      label: Text("Provinsi"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: description,
                  maxLines: 3,
                  minLines: 3,
                  decoration: InputDecoration(
                      label: Text("Keterangan Tambahan"),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
