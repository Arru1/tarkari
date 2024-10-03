import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreenProduct extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String sellername;

  const MapScreenProduct({
    required this.latitude,
    required this.longitude,
    required this.sellername,
    Key? key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreenProduct> {
  late LatLng _currentLatLng;
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLatLng = LatLng(widget.latitude, widget.longitude);
    _markers.add(
      Marker(
        markerId: MarkerId("currentLocation"),
        position: _currentLatLng,
        infoWindow: InfoWindow(title: widget.sellername),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLatLng,
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: _markers,
      ),
    );
  }
}
