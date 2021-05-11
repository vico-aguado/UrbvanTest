
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const GOOGLE_API_KEY = "YOUR API KEY HERE";

const red_dark_color = Color.fromRGBO(197, 40, 49, 1);
const red_light_color = Color.fromRGBO(240, 69, 79, 1);
const secondsToGetLocation = 10;

const CameraPosition kGoogleInitialPosition= CameraPosition(
    target: LatLng(21.121361, -101.683403),
    zoom: 0,
  );