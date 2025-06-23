import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ParkingSpotModel {
  final String? note;
  final DateTime? time; // Formerly "Timer" in Firebase
  final DateTime createdAt;
  final double latitude;
  final double longitude;
  final String? photoPath;
  final String? userId;

  ParkingSpotModel({
    this.note,
    this.time,
    required this.createdAt,
    required this.latitude,
    required this.longitude,
    this.photoPath,
    this.userId,
  });

  LatLng get latLng => LatLng(latitude, longitude);

  Map<String, dynamic> toMap() {
    return {
      'note': note,
      'Timer':
          time != null
              ? Timestamp.fromDate(time!)
              : null, // Match Firestore field
      'createdAt': Timestamp.fromDate(createdAt),
      'location': GeoPoint(latitude, longitude),
      'photoPath': photoPath,
      'userId': userId,
    };
  }

  factory ParkingSpotModel.fromMap(Map<String, dynamic> map) {
    final GeoPoint geoPoint = map['location'];

    return ParkingSpotModel(
      note: map['note'],
      time: map['Timer'] != null ? (map['Timer'] as Timestamp).toDate() : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
      photoPath: map['photoPath'],
      userId: map['userId'],
    );
  }
}
