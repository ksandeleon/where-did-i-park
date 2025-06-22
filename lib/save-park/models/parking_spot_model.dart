import 'package:geolocator/geolocator.dart';

class ParkingSpot {
  final String? note;
  final DateTime? time;
  final Position location;
  // final XFile? photo;

  ParkingSpot({
    this.note,
    this.time,
    required this.location,
    // this.photo,
  });
}
