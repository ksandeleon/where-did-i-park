import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:where_did_i_park/save-park/components/add_parking.dart';
import 'package:where_did_i_park/save-park/components/nav_to_history.dart';
import 'package:where_did_i_park/save-park/components/parking_carousel.dart';
import 'package:where_did_i_park/save-park/screens/parking_form.dart';

class SaveParkRoot extends StatefulWidget {
  const SaveParkRoot({super.key});

  @override
  State<SaveParkRoot> createState() => _SaveParkRootState();
}

class _SaveParkRootState extends State<SaveParkRoot> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Metro Manila",
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
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AddParkingCard(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ParkingForm()),
                    );
                  },
                ),
                ParkingCarousel(),
                SizedBox(height: 30),
                NavToHistory(
                  onTap: () async {
                    try {
                      final querySnapshot =
                          await FirebaseFirestore.instance
                              .collection('GoParking')
                              .orderBy('timestamp', descending: true)
                              .limit(1)
                              .get();

                      if (querySnapshot.docs.isEmpty) {
                        showCustomSnackbar(context, "You have no parking yet");
                      } else {
                        final parkingData = querySnapshot.docs.first.data();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParkingForm(),
                          ),
                        );
                      }
                    } catch (e) {
                      print("Error fetching parking history: $e");
                      showCustomSnackbar(
                        context,
                        "Something went wrong. Try again later.",
                      );
                    }
                  },
                ),

                SizedBox(height: 35),
                Text(
                  "Go Parking App",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black45,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
