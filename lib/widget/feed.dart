import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:society_road/model/reportModel.dart';
import 'package:society_road/webservice/reportService.dart';
import 'package:society_road/webservice/url.dart';
import 'package:society_road/widget/snackbarAlert.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';

class FeedWidget extends StatefulWidget {
  FeedWidget({Key? key}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  List<ReportModel> data = [];
  bool isProcessing = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doFetchData();
  }

  Future<String> getCity() async {
    Position currentPosition = await _determinePosition(context);
    List<Placemark> placemark = await placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.latitude);
    print(placemark);
    return placemark[0].subAdministrativeArea!;
  }

  Future<Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackbar(context, 'Mohon Aktifkan GPS !');
      await Geolocator.openLocationSettings();
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackbar(context, 'Mohon Aktifkan Perizinan GPS pada aplikasi');
        await Geolocator.openAppSettings();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showSnackbar(context,
          'Location permissions are permanently denied, we cannot request permissions.');
      await Geolocator.openLocationSettings();
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void doFetchData() async {
    try {
      String city = await getCity();
      print(city);
      List<ReportModel> resultFetch = await ReportService.getCollectionReport(
          city: "Kabupaten Lamongan", page: 1);
      setState(() {
        data = resultFetch;
        isProcessing = false;
      });
      print(resultFetch);
    } catch (e) {
      print(e);
    }
  }

  void gotoMap(double lang, double lat) async {
    final availableMaps = await MapLauncher.installedMaps;
    print(
        availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first
        .showMarker(coords: Coords(lat, lang), title: "OKE JEK");
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
                  onTap: () {
                    gotoMap(double.parse(e.lang), double.parse(e.lat));
                  },
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
          title: Text("Jalan Rusak Sekitar"),
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
