import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingSpotModel {
  final String? note;
  final String? timer;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? imagePath;
  final String? userId;

  ParkingSpotModel({
    this.note,
    this.timer,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.imagePath,
    this.userId,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'timer': timer,
      'timestamp': Timestamp.fromDate(timestamp),
      'location': GeoPoint(latitude, longitude),
      'imagePath': imagePath,
      'userId': userId,
    };
  }

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map) {
    final GeoPoint geoPoint = map['location'];


    return ParkingSpotModel(
      note: map['note'],
      timer: map['timer']?.toString(),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
      imagePath: map['imagePath'],
      userId: map['userId'],
    );
  }
}
