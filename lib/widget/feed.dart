import 'package:flutter/material.dart';
import 'package:society_road/model/reportModel.dart';
import 'package:society_road/webservice/reportService.dart';
import 'package:society_road/webservice/url.dart';

class FeedWidget extends StatefulWidget {
  FeedWidget({Key? key}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  List<ReportModel> data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doFetchData();
  }

  void doFetchData() async {
    try {
      List<ReportModel> resultFetch = await ReportService.getCollectionReport(
          city: "Kabupaten Lamongan", page: 1);
      setState(() {
        data = resultFetch;
      });
      print(resultFetch);
    } catch (e) {
      print(e);
    }
  }

  Widget DataReport() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: data
          .map((e) => (Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(e.address),
                  subtitle: Text('${e.city} - ${e.province}'),
                  trailing: Icon(Icons.location_on),
                ),
              )))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Jalan Rusak"),
      ),
      body:  Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [data.length > 0 ? DataReport() : SizedBox()],
      ),
    )
    );
  }
}
