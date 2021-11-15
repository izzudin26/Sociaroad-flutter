import 'package:flutter/material.dart';

class FeedWidget extends StatefulWidget {
  FeedWidget({Key? key}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("FeedPage")));
  }
}
