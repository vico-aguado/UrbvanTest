import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbvan/app/utils/geo_util.dart';
import 'package:urbvan/app/widgets/dialog_widget.dart';
import 'package:urbvan/configuration.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class RoutesScreen extends StatefulWidget {
  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final PolylinePoints polylinePoints = PolylinePoints();

  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();

  double totalDistance = 0.0;

  _addMarker(LatLng position) {
    _markers.add(Marker(
      markerId: MarkerId('locationPin_' + DateTime.now().millisecondsSinceEpoch.toString()),
      position: position,
      icon: BitmapDescriptor.defaultMarker,
    ));

    if (_markers.length >= 2) {
      _createPolyline(_markers.elementAt(_markers.length - 2).position, _markers.last.position);
    }

    setState(() {});
  }

  _createPolyline(LatLng start, LatLng destination) async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_API_KEY,
        PointLatLng(start.latitude, start.longitude),
        PointLatLng(destination.latitude, destination.longitude),
        travelMode: TravelMode.transit,
      );

      List<LatLng> _polylineCoordinates = [];

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }

      PolylineId id = PolylineId('polyline' + (_polylines.length + 1).toString());

      Polyline polyline = Polyline(
        polylineId: id,
        color: red_light_color,
        points: _polylineCoordinates,
        width: 3,
      );

      _polylines.add(polyline);

      _calculateDistance();

      setState(() {});
    } catch (e) {
      print(e);

      String errorText = e.toString().contains("Failed host lookup") ? "No hay conexión a internet.\nInténtalo más tarde." : e.toString();

      showAlertDialog(
        context: context,
        title: "¡Alerta!",
        height: e.toString().contains("Failed host lookup") ? 200 : 400,
        message: errorText
      );
    }
  }

  _calculateDistance() {
    totalDistance = 0;
    for (Polyline polyline in _polylines) {
      for (int i = 0; i < polyline.points.length - 1; i++) {
        totalDistance += coordinateDistance(
          polyline.points[i].latitude,
          polyline.points[i].longitude,
          polyline.points[i + 1].latitude,
          polyline.points[i + 1].longitude,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(fit: StackFit.expand, children: [
              GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                markers: _markers,
                polylines: _polylines,
                initialCameraPosition: kGoogleInitialPosition,
                zoomControlsEnabled: false,
                onLongPress: (position) {
                  print(position);
                  _addMarker(position);
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              if (totalDistance > 0)
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
                            "Distancia: ${totalDistance.toStringAsFixed(3)} kms",
                            style: GoogleFonts.lato(color: Colors.white),
                          ),
                        ))),
              Positioned(
                  bottom: 40,
                  left: 10,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_markers.length > 0) {
                            _markers.remove(_markers.last);
                          }

                          if (_polylines.length > 0) {
                            _polylines.remove(_polylines.last);
                          }

                          _calculateDistance();

                          setState(() {});
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
                              Icons.wrong_location,
                              color: Colors.white,
                            ),
                          ),
                          width: 40,
                          height: 45,
                        ),
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _markers.clear();
                            _polylines.clear();
                            totalDistance = 0;
                          });
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
                              Icons.highlight_off,
                              color: Colors.white,
                            ),
                          ),
                          width: 40,
                          height: 45,
                        ),
                      ),
                    ],
                  ))
            ])));
  }
}
