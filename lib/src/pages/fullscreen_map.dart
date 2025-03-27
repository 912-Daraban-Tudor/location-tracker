import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracker/src/domain/model/location.dart';

class FullScreenMap extends StatelessWidget {
  final Location location;

  const FullScreenMap({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location.nameOfLocation),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 20,
        ),
        markers: {
          Marker(
            markerId: MarkerId("location_marker"),
            position: LatLng(location.latitude, location.longitude),
          ),
        },
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}
          ..add(Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())),
      ),
    );
  }
}
