import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:where_did_i_park/save-park/models/parking_spot_model.dart';
import 'package:where_did_i_park/save-park/services/location_service.dart';
import 'dart:io';

class LocateParkingRoot extends StatefulWidget {
  final Map<String, dynamic>? initialParkingData;

  const LocateParkingRoot({super.key, this.initialParkingData});

  @override
  State<LocateParkingRoot> createState() => _LocateParkingRootState();
}

class _LocateParkingRootState extends State<LocateParkingRoot> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng _initialPosition = LatLng(14.5736108, 121.0329706);
  bool _locationLoaded = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadMarkers();

    // If initialParkingData is provided, focus on that location
    if (widget.initialParkingData != null) {
      _focusOnInitialParkingData();
    }
  }

  void _focusOnInitialParkingData() {
    if (widget.initialParkingData != null &&
        widget.initialParkingData!['location'] != null) {
      GeoPoint geoPoint = widget.initialParkingData!['location'];
      LatLng parkingLocation = LatLng(geoPoint.latitude, geoPoint.longitude);

      setState(() {
        _initialPosition = parkingLocation;
      });

      // Show the bottom sheet for this parking data automatically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showBottomSheet(widget.initialParkingData!);
      });
    }
  }

  Future<void> _determinePosition() async {
    try {
      Position position = await LocationService().determinePosition();

      // Only update position if no initial parking data was provided
      if (widget.initialParkingData == null) {
        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);
        });
      }

      setState(() {
        _locationLoaded = true;
      });

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLng(_initialPosition));
      }
    } catch (e) {
      print("Error getting location: $e");
      setState(() {
        _locationLoaded = true; // Still loaded, just using default position
      });
    }
  }

  Future<void> _loadMarkers() async {
    QuerySnapshot snapshot =
        await _firestore
            .collection('GoParking')
            .where('location', isNotEqualTo: null)
            .get();

    Set<Marker> newMarkers = {};

    for (var doc in snapshot.docs) {
      GeoPoint geoPoint = doc['location'];
      String documentId = doc.id;
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

      // Highlight the initial parking data marker if provided
      bool isInitialMarker =
          widget.initialParkingData != null &&
          widget.initialParkingData!['location'] != null &&
          widget.initialParkingData!['location'] == geoPoint;

      newMarkers.add(
        Marker(
          markerId: MarkerId(documentId),
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          // Use different color for the initial parking marker
          icon:
              isInitialMarker
                  ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  )
                  : BitmapDescriptor.defaultMarker,
          onTap: () {
            _showBottomSheet(docData);
          },
        ),
      );
    }

    setState(() {
      markers = newMarkers;
    });
  }

  void _showBottomSheet(Map<String, dynamic> markerData) {
    // Convert Firestore data to ParkingSpotModel
    final parkingSpot = ParkingSpotModel.fromMap(markerData);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.75, // Increased height
          child: Column(
            children: [
              // Draggable handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Text(
                "Parking Details",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parking Note
                      if (parkingSpot.note != null &&
                          parkingSpot.note!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Note:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(parkingSpot.note!),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // Timer
                      if (parkingSpot.timer != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Parking Duration:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(parkingSpot.timer!),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // Timestamp
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parked at:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'MMM dd, yyyy - hh:mm a',
                            ).format(parkingSpot.timestamp),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                      // Coordinates
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Coordinates:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Latitude: ${parkingSpot.latitude.toStringAsFixed(6)}",
                          ),
                          Text(
                            "Longitude: ${parkingSpot.longitude.toStringAsFixed(6)}",
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),

                      // Replace the existing image placeholder code with this:
                      if (parkingSpot.imagePath != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Parking Photo:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    parkingSpot.imagePath!.startsWith('http')
                                        ? Image.network(
                                          parkingSpot.imagePath!,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (
                                            context,
                                            child,
                                            loadingProgress,
                                          ) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                              ),
                                            );
                                          },
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        )
                                        : Image.file(
                                          File(parkingSpot.imagePath!),
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

              // Close button with better styling
              Container(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // More prominent color
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2, // Add some shadow
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Find My Vehicle",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_2_outlined, size: 28),
            tooltip: 'Sign In / Sign Up',
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Account tapped')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined), // Modern settings icon
            tooltip: 'Settings',
            onPressed: () {
              // Handle settings navigation here
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Settings tapped')));
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
              // Focus on initial position when map is ready
              if (widget.initialParkingData != null) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _initialPosition,
                      zoom: 16, // Higher zoom for better focus
                    ),
                  ),
                );
              }
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: widget.initialParkingData != null ? 16 : 12,
            ),
            markers: markers,
          ),
        ),
      ),
    );
  }
}
