import 'package:flutter/material.dart';
import 'package:society_road/model/reportModel.dart';
import 'package:society_road/webservice/reportService.dart';
import 'package:society_road/widget/snackbarAlert.dart';

class ReportWidget extends StatefulWidget {
  ReportWidget({Key? key}) : super(key: key);

  @override
  _ReportWidgetState createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  List<ReportModel> data = [];
  bool isProcessing = true;

  @override
  void initState() {
    super.initState();
    doFetchData();
  }

  void doFetchData() async {
    try {
      List<ReportModel> resultFetch = await ReportService.getPersonReport();
      setState(() {
        data = resultFetch;
        isProcessing = false;
      });
      print(resultFetch);
    } catch (e) {
      print(e);
    }
  }

  void removeReport(ReportModel r) async {
    int index = data.indexOf(r);
    setState(() {
      isProcessing = true;
    });
    try {
      await ReportService.removeReport(reportId: r.reportId);
      setState(() {
        data.removeAt(index);
        isProcessing = false;
      });
      showSnackbar(context, "Berhasil Menghapus Laporan");
    } catch (e) {
      print(e);
      showSnackbar(context, "Terjadi Kesalahan");
    }
  }

  Widget DataReport() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: data
          .map((r) => (Container(
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
                  title: Text(r.address),
                  subtitle: Text('${r.city} - ${r.province}'),
                  leading: Icon(Icons.location_on),
                  trailing: IconButton(
                      onPressed: () {
                        removeReport(r);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
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
          title: Text("Laporan Anda"),
          bottom: !isProcessing
              ? null
              : PreferredSize(
                  child: LinearProgressIndicator(),
                  preferredSize: Size.fromHeight(.5)),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [data.length > 0 ? DataReport() : SizedBox()],
          ),
        ));
  }
}
