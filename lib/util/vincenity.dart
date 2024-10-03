import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';

class Vincenty {
  static LocationData? currentLocation;

  static Future<void> updateCurrentLocation() async {
    Location location = Location();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      print('Could not get the current location: $e');
    }
  }

  static Future<double> calculateDistance(
      double? destLat, double? destLon) async {
    if (currentLocation == null) {
      await updateCurrentLocation();
    }

    if (currentLocation != null) {
      double currentLat = currentLocation!.latitude!;
      double currentLon = currentLocation!.longitude!;
      return vincentyDistance(currentLat, currentLon, destLat, destLon);
    } else {
      return -1.0;
    }
  }

  static double vincentyDistance(
      double currentLat, double currentLon, double? destLat, double? destLon) {
    const double a = 6378137; 
    const double f = 1 / 298.257223563;

    
    currentLat = _degreesToRadians(currentLat);
    currentLon = _degreesToRadians(currentLon);
    destLat = _degreesToRadians(destLat!);
    destLon = _degreesToRadians(destLon!);

    double L = destLon - currentLon;
    double tanU1 = (1 - f) * tan(currentLat);
    double cosU1 = 1 / sqrt((1 + tanU1 * tanU1));
    double sinU1 = tanU1 * cosU1;
    double tanU2 = (1 - f) * tan(destLat);
    double cosU2 = 1 / sqrt((1 + tanU2 * tanU2));
    double sinU2 = tanU2 * cosU2;

    double lambda = L;
    double prevLambda;
    double cosSqAlpha;
    double sigma;
    double cosSigma;
    double sinSigma;
    double cos2SigmaM;
    double C;

    do {
      double sinLambda = sin(lambda);
      double cosLambda = cos(lambda);
      sinSigma = sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda) +
          (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) *
              (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
      if (sinSigma == 0) return 0; // Co-incident points
      cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
      sigma = atan2(sinSigma, cosSigma);
      double sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
      cosSqAlpha = 1 - sinAlpha * sinAlpha;
      cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
      C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
      prevLambda = lambda;
      lambda = L +
          (1 - C) *
              f *
              sinAlpha *
              (sigma +
                  C *
                      sinSigma *
                      (cos2SigmaM +
                          C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while ((lambda - prevLambda).abs() > 1e-12);

    double uSq = cosSqAlpha * (a * a - a * a) / (a * a);
    double A = 1 +
        uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    double deltaSigma =
        B * sinSigma * (cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) -
            B /
                6 *
                cos2SigmaM *
                (-3 + 4 * sinSigma * sinSigma) *
                (-3 + 4 * cos2SigmaM * cos2SigmaM)));
    double s = a * A * (sigma - deltaSigma);

    return s/1000;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}
