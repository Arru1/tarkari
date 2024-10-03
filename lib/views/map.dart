import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart' show LocationData;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentLatLng = LatLng(0, 0);
  GoogleMapController? _controller;
  Set<Marker> _markers = {};

  late location.Location _location;
  late StreamSubscription<location.LocationData>? _locationSubscription;

  TextEditingController _searchController = TextEditingController();

  double _tappedLatitude = 0.0;
  double _tappedLongitude = 0.0;
  String _bottomNavText = '';

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initLocation() async {
    _location = location.Location();

    LocationData? initialLocation = await _location.getLocation();
    if (initialLocation != null) {
      _updateLocation(initialLocation.latitude!, initialLocation.longitude!);
    }

    _locationSubscription = _location.onLocationChanged
        .listen((location.LocationData currentLocation) {
      _updateLocation(currentLocation.latitude!, currentLocation.longitude!);
    });
  }

  void _updateLocation(double latitude, double longitude) {
    setState(() {
      _currentLatLng = LatLng(latitude, longitude);
    });
  }

  Future<void> _searchLocation(String query) async {
    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(query);
      if (locations.isNotEmpty) {
        geocoding.Location location = locations.first;

        double latitude = location.latitude!;
        double longitude = location.longitude!;

        setState(() {
          _currentLatLng = LatLng(latitude, longitude);
          _markers.clear();
          _markers.add(
            Marker(
              markerId: MarkerId("searchedLocation"),
              position: _currentLatLng,
              infoWindow: InfoWindow(title: "Searched Location"),
            ),
          );
        });

        print("Searched Location: $latitude, $longitude");
      }
    } catch (e) {
      print("Error searching location: $e");
    }
  }

  void _moveToCurrentLocation() async {
    LocationData currentLocation = await _location.getLocation();
    _updateLocation(currentLocation.latitude!, currentLocation.longitude!);

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          position: _currentLatLng,
          infoWindow: InfoWindow(title: "Current Location"),
        ),
      );

      _tappedLatitude = currentLocation.latitude!;
      _tappedLongitude = currentLocation.longitude!;
      _bottomNavText =
          'Latitude: $_tappedLatitude, Longitude: $_tappedLongitude';
    });

    _controller?.animateCamera(CameraUpdate.newLatLng(_currentLatLng));
  }

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      _tappedLatitude = tappedPoint.latitude;
      _tappedLongitude = tappedPoint.longitude;
      _bottomNavText =
          'Latitude: $_tappedLatitude, Longitude: $_tappedLongitude';

      _currentLatLng = tappedPoint;
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId("tappedLocation"),
          position: _currentLatLng,
          infoWindow: InfoWindow(title: "Tapped Location"),
        ),
      );
    });

    print("Tapped Location: $_tappedLatitude, $_tappedLongitude");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLatLng,
              zoom: 15.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: _markers,
            onTap: (LatLng tappedPoint) {
              _onMapTap(tappedPoint);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20)),
                    child: TextField(
                      style: TextStyle(
                          fontStyle: FontStyle.normal, color: Colors.black87),
                      controller: _searchController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.green, // Border color when focused
                            width: 2.0,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.green.shade400, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            await _searchLocation(_searchController.text);
                            _controller?.animateCamera(
                              CameraUpdate.newLatLng(_currentLatLng),
                            );
                          },
                        ),
                        hintText: 'Search for a location',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
  padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
  child: Align(
    alignment: Alignment.bottomLeft,
    child: FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(1),
      onPressed: () async {
        _moveToCurrentLocation();
      },
      tooltip: 'Move to Current Location',
      child: Icon(Icons.my_location),
    ),
  ),
),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on_outlined,
              color: Colors.green.shade400,
              size: 30,
            ),
            label: 'Select',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
              color: Colors.green.shade400,
              size: 30,
            ),
            label: 'Info',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Location Information'),
                  content: Text(_bottomNavText),
                  actions: [
                    TextButton(
                      onPressed: () {
                        print(_tappedLatitude);
                        print(_tappedLongitude);
                        Navigator.pop(context, {
                          'latitude': _tappedLatitude,
                          'longitude': _tappedLongitude,
                        });
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            ).then((value) {
              print("Latitude before popping: $_tappedLatitude");
              print("Longitude before popping: $_tappedLongitude");
              if (value != null &&
                  value['latitude'] != null &&
                  value['longitude'] != null) {
                Navigator.pop(context, {
                  'latitude': _tappedLatitude,
                  'longitude': _tappedLongitude,
                });
              }
            });
          }
        },
      ),
    );
  }
}
