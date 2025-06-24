import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:where_did_i_park/save-park/components/fetch_my_current_loc.dart';
import 'package:where_did_i_park/save-park/services/camera_service.dart';
import 'package:where_did_i_park/save-park/services/location_service.dart';
import 'package:where_did_i_park/save-park/services/user_service.dart';

class ParkingForm extends StatefulWidget {
  const ParkingForm({super.key});

  @override
  State<ParkingForm> createState() => _ParkingFormState();
}

class _ParkingFormState extends State<ParkingForm> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(14.6507, 121.1029);
  final TextEditingController _noteController = TextEditingController();
  TimeOfDay? _selectedTime;
  File? _imageFile;
  Set<Marker> _markers = {};

  final locationService = LocationService();
  final _cameraService = CameraService();

  @override
  void initState() {
    super.initState();
    _checkLostData();
  }

  void showCustomSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.black45,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        padding: const EdgeInsets.only(bottom: 14, top: 14),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  void _takePicture() async {
    final image = await _cameraService.takePhoto();
    if (image != null) {
      setState(() {
        _imageFile = image;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
            child: const Text(
              'Parking photo saved successfully!',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          backgroundColor: Colors.black45,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          padding: const EdgeInsets.only(bottom: 14, top: 14),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  void _checkLostData() async {
    final lostImage = await _cameraService.handleLostData();
    if (lostImage != null) {
      print('Recovered lost photo: ${lostImage.path}');
      // Recover in UI
    }
  }

  void _handleMapTap(LatLng tappedPoint) {
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId("selected_parking_spot"),
          position: tappedPoint,
          infoWindow: InfoWindow(title: "Selected Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      };
    });
  }

  void _getLocation() async {
    try {
      final position = await locationService.determinePosition();

      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      setState(() {
        _markers = {
          Marker(
            markerId: MarkerId("current_location"),
            position: currentLatLng,
            infoWindow: InfoWindow(title: "You are here"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        };
      });

      // Move the camera to the new marker
      mapController.animateCamera(CameraUpdate.newLatLng(currentLatLng));
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input, // ⌨ Keyboard style
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  Future<void> _saveParkingSpot() async {
    if (_markers.isEmpty) {
      showCustomSnackbar(context, "Please select a location on the map");
      return;
    }

    final note = _noteController.text.trim();
    final timestamp = Timestamp.now();
    final imagePath = _imageFile?.path;
    final selectedTime = _selectedTime?.format(context);

    final selectedMarker = _markers.first;
    final location = GeoPoint(
      selectedMarker.position.latitude,
      selectedMarker.position.longitude,
    );

    final userId = await getOrCreateUserId();

    try {
      await FirebaseFirestore.instance.collection('GoParking').add({
        'note': note,
        'timestamp': timestamp,
        'timer': selectedTime,
        'imagePath': imagePath,
        'location': location,
        'userId': userId,
      });

      showCustomSnackbar(context, "Parking Spot Saved Succesfully!");

      Navigator.pop(context); // close the form
    } catch (e) {
      print('Error saving to Firestore: $e');
      showCustomSnackbar(context, "App Error: Parking Spot Failed To Save");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // automaticallyImplyLeading: false,
        title: const Text(
          "Add Parking Location",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Map
            Expanded(
              flex: 7,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 15.0,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                onTap: _handleMapTap,
                markers: _markers,
              ),
            ),

            // Bottom card
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8),
                    // Write Note (single line)
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        labelText: 'Write Note (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Add Timer
                    ElevatedButton(
                      onPressed: _pickTime,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      child: Text(
                        _selectedTime == null
                            ? 'Add Timer (Optional)'
                            : 'Timer: ${_selectedTime!.format(context)}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Take Photo
                    ElevatedButton(
                      onPressed: _takePicture,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      child: Text(
                        _imageFile == null ? "Take Photo (Optional)" : "Take A New Photo",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    SizedBox(height: 4),

                    FetchCurrentLocation(
                      onTap: () {
                        // Handle settings navigation here
                        _getLocation();
                      },
                    ),

                    const Spacer(),

                    // Save and Discard buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Discard
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Save
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _saveParkingSpot();
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.teal),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.teal),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
