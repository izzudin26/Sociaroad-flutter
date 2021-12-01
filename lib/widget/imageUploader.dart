import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:society_road/model/imagePickerModel.dart';
import 'package:society_road/webservice/reportService.dart';
import 'package:society_road/webservice/url.dart';
import 'package:society_road/widget/snackbarAlert.dart';

class ImageUploader extends StatefulWidget {
  int reportId;
  ImageUploader({Key? key, required this.reportId}) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  late XFile image;

  List<ImagePickerModel> images = [];
  final ImagePicker _picker = ImagePicker();

  bool isProcessing = false;

  void pickImage(String type) async {
    try {
      XFile? img = await _picker.pickImage(
          source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
      if (img != null) {
        setState(() {
          isProcessing = true;
        });
        ImagePickerModel image = await ReportService.uploadImage(
            reportId: widget.reportId, image: new File(img.path));
        setState(() {
          images.add(image);
          isProcessing = false;
        });
        print(images);
      }
    } catch (e) {
      print(e);
    }
  }

  void removeImage(int index) async {
    print("hit");
    try {
      await ReportService.removeAssetImage(imageId: images[index].id!);
      setState(() {
        images.removeAt(index);
      });
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  void doUpload() async {
    Navigator.pushReplacementNamed(context, "/navigation");
  }

  Widget showImages() {
    return Container(
      child: Column(
          children: images
              .asMap()
              .map((i, e) => MapEntry(
                  i,
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Stack(
                      children: [
                        Container(
                          child: Image.network(
                              '$serverUrl/asset/${e.locationPath}'),
                        ),
                        IconButton(
                            onPressed: () {
                              removeImage(i);
                            },
                            icon: Icon(Icons.close, color: Colors.red))
                      ],
                    ),
                  )))
              .values
              .toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Upload Gambar", style: TextStyle(color: Colors.blue)),
        bottom: !isProcessing
            ? null
            : PreferredSize(
                child: LinearProgressIndicator(),
                preferredSize: Size.fromHeight(.5)),
        actions: [
          TextButton(
              onPressed: () {
                doUpload();
              },
              child: Text("Laporkan", style: TextStyle(color: Colors.blue)))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              showImages(),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                            height: MediaQuery.of(context).size.height * .15,
                            child: InkWell(
                              onTap: () {
                                pickImage("gallery");
                              },
                              child: Icon(Icons.image, color: Colors.blue),
                            )))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
