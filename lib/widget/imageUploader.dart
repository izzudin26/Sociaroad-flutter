import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:society_road/model/imagePickerModel.dart';

class ImageUploader extends StatefulWidget {
  ImageUploader({Key? key}) : super(key: key);

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  late XFile image;

  List<String> images = [];
  final ImagePicker _picker = ImagePicker();

  void pickImage(String type) async {
    try {
      XFile? img = await _picker.pickImage(
          source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
      if (img != null) {
        print(img.path);
        setState(() {
          images.add(img.path);
        });
        print(images);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget showImages() {
    return Container(
      child: Column(
          children: images
              .map((e) => Stack(
                    children: [
                      Container(
                        child: Image.file(File(e)),
                      )
                    ],
                  ))
              .toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Upload Gambar"),
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
