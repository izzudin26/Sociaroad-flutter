import 'package:flutter/material.dart';
import 'package:society_road/widget/feed.dart';
import 'package:society_road/widget/map.dart';
import 'package:society_road/widget/report.dart';


class NavigationApp extends StatefulWidget {
  NavigationApp({Key? key}) : super(key: key);

  @override
  _NavigationAppState createState() => _NavigationAppState();
}

class _NavigationAppState extends State<NavigationApp> {
  List<Widget> widgets = [
    MapWidget(),
    FeedWidget(),
    ReportWidget()
    
  ];
  int currentWidget = 0;

  void setWidget(int index) {
    setState(() {
      currentWidget = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets[currentWidget],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_road), label: "Feed"),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: "Laporan")
        ],
        currentIndex: currentWidget,
        onTap: setWidget,
      ),
    );
  }
}