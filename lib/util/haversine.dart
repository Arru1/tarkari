import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';

class HaversineDistance {
  static LocationData? currentLocation;

  static Future<void> updateCurrentLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print('Could not get the current location: $e');
    }
  }

  static Future<double> calculateDistanceWithCurrentLocation(
      double? destLat, double? destLon) async {
    if (currentLocation == null) {
      await updateCurrentLocation();
    }

    if (currentLocation != null) {
      double currentLat = currentLocation!.latitude!;
      double currentLon = currentLocation!.longitude!;
      return haversineDistance(currentLat, currentLon, destLat, destLon);
    } else {
      return -1.0;
    }
  }

  static double haversineDistance(
      double currentLat, double currentLon, double? destLat, double? destLon) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double toRadians(double degree) {
      return degree * pi / 180;
    }

    // Calculate differences between latitude and longitude
    double dLat = toRadians(destLat! - currentLat);
    double dLon = toRadians(destLon! - currentLon);

    // Convert latitudes to radians
    currentLat = toRadians(currentLat);
    destLat = toRadians(destLat!);

    // Haversine formula
    double a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) * cos(currentLat) * cos(destLat);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance; // Distance in kilometers
  }
}