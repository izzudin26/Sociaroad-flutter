import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:society_road/createReport.dart';
import 'dart:async';
import 'package:society_road/widget/snackbarAlert.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapWidget extends StatefulWidget {
  MapWidget({Key? key}) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void setCurrentPosition(double lang, double lat) async {
    CameraPosition _currentPosition =
        CameraPosition(target: LatLng(lat, lang), zoom: 19.151926040649414);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_currentPosition));
  }

  void getAndSetPosition(BuildContext context) async {
    Position current = await _determinePosition(context);
    setCurrentPosition(current.longitude, current.latitude);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          getAndSetPosition(context);
        },
      ),
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 70),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: "insertBtn",
                  // backgroundColor: Color(0XFF0D325E),
                  backgroundColor: Colors.red,
                  // child: Icon(Icons.refresh),
                  label: Text('Buat Laporan'),
                  onPressed: () async {
                    Position currentlocation =
                        await _determinePosition(context);
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        currentlocation.latitude, currentlocation.longitude);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateReport(
                                  lang: currentlocation.longitude.toString(),
                                  lat: currentlocation.latitude.toString(),
                                  address:
                                      '${placemarks[0].street} - ${placemarks[0].locality}',
                                  city: placemarks[0].subAdministrativeArea!,
                                  province: placemarks[0].administrativeArea!,
                                )));
                  }),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "getCurrentLocationBtn",
                backgroundColor: Colors.blue,
                child: Icon(Icons.location_on),
                onPressed: () {
                  getAndSetPosition(context);
                }),
          ),
        ],
      ),
    );
  }
}
