import 'package:flutter/material.dart';

class ReportWidget extends StatefulWidget {
  ReportWidget({Key? key}) : super(key: key);

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Report widget"),
      ),
    );
  }
}