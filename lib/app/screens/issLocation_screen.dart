import 'dart:async';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:urbvan/app/utils/image_util.dart';
import 'package:urbvan/app/widgets/dialog_widget.dart';
import 'package:urbvan/configuration.dart';
import 'package:urbvan/core/controllers/app_controller.dart';
import 'package:get/get.dart';
import 'package:urbvan/core/models/issLocation_model.dart';
import 'package:google_fonts/google_fonts.dart';

class ISSLocationScreen extends StatefulWidget {
  @override
  _ISSLocationScreenState createState() => _ISSLocationScreenState();
}

class _ISSLocationScreenState extends State<ISSLocationScreen> {
  final AppController _appController = Get.find<AppController>();
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<ISSLocationModel> liveISSLocationsubscription;

  double zoom = 1;
  ISSLocationModel actualLocation;

  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor sourceIcon;

  _gotoLocation(ISSLocationModel data) async {
    actualLocation = data;

    final GoogleMapController controller = await _controller.future;
    zoom = await controller.getZoomLevel();
    final CameraPosition _camera = CameraPosition(target: LatLng(data.latitude, data.longitude), zoom: zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(_camera));

    var pinPosition = LatLng(data.latitude, data.longitude);

    setState(() {
      _markers.removeWhere((m) => m.markerId.value.contains('locationPin'));
      _markers.add(Marker(markerId: MarkerId('locationPin2'), position: pinPosition, icon: sourceIcon));
    });
  }

  _zoomFunction(double value) async {
    final GoogleMapController controller = await _controller.future;
    zoom = await controller.getZoomLevel();
    zoom += value;
    final CameraPosition _camera = CameraPosition(target: LatLng(actualLocation.latitude, actualLocation.longitude), zoom: zoom);
    controller.animateCamera(CameraUpdate.newCameraPosition(_camera));
  }

  void _setIcon() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/images/location.png', 100);
    sourceIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  @override
  void initState() {
    _setIcon();
    super.initState();

    _appController.api.getISSLocation().then((value) {
      _gotoLocation(value);
    }).catchError((e) {
      print(e);

      String errorText = e.toString().contains("Failed host lookup") ? "No hay conexión a internet.\nInténtalo más tarde." : e.toString();

      showAlertDialog(context: context, title: "¡Alerta!", height: e.toString().contains("Failed host lookup") ? 200 : 400, message: errorText);
    });

    liveISSLocationsubscription = _appController.getLiveISSLocation().listen((event) {
      _gotoLocation(event);
    }, onError: (e) {
      String errorText = e.toString().contains("Failed host lookup") ? "No hay conexión a internet.\nInténtalo más tarde." : e.toString();

      showAlertDialog(context: context, title: "¡Alerta!", height: e.toString().contains("Failed host lookup") ? 200 : 400, message: errorText);
    });
  }

  @override
  void dispose() {
    if (liveISSLocationsubscription != null) {
      liveISSLocationsubscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              markers: _markers,
              zoomControlsEnabled: false,
              initialCameraPosition: kGoogleInitialPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            if (actualLocation != null)
              Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: red_light_color,
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                      ),
                      child: Center(
                        child: Text(
                          "Latitud: ${actualLocation.latitude},   Longitud: ${actualLocation.longitude}",
                          style: GoogleFonts.lato(color: Colors.white),
                        ),
                      ))),
            if (actualLocation != null)
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _zoomFunction(0.1);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: red_light_color,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                          width: 40,
                          height: 40,
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (zoom > 0) {
                            _zoomFunction(-0.1);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: red_light_color,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ))
          ],
        ),
      ),
    );
  }
}
