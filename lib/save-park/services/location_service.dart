import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get current position
    Position result = await Geolocator.getCurrentPosition();
    print(result);
    return result;
  }

  Future<LocationData> determinePosition1() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationData(error: 'Location services are disabled');
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationData(error: 'Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationData(
          error: 'Location permissions are permanently denied',
        );
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String cityName = 'GPS Off';
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        cityName =
            place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            'Unknown Location';
      }

      return LocationData(position: position, cityName: cityName);
    } catch (e) {
      return LocationData(error: 'Error getting location: $e');
    }
  }
}

class LocationData {
  final Position? position;
  final String? cityName;
  final String? error;

  LocationData({this.position, this.cityName, this.error});

  bool get hasError => error != null;
  bool get hasLocation => position != null;
}
