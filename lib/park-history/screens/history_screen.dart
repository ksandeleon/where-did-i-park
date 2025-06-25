import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_did_i_park/save-park/models/parking_spot_model.dart';
import 'package:where_did_i_park/save-park/services/user_service.dart';

class HistoryScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onNavigateToLocate;

  const HistoryScreen({super.key, this.onNavigateToLocate});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<ParkingSpotModel>> futureParkings;
  final GlobalKey _allParkingKey = GlobalKey();

  Future<List<ParkingSpotModel>> fetchUserParkings() async {
    final userId = await getOrCreateUserId();

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('GoParking')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => ParkingSpotModel.fromMap(doc.data()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    futureParkings = fetchUserParkings();
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
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // Function to handle ListTile tap - similar to NavToHistory functionality
  void handleParkingTap(ParkingSpotModel parking) async {
    try {
      // Convert ParkingSpotModel to Map<String, dynamic> for navigation
      final parkingData = parking.toMap();

      // Use the callback to navigate to locate tab
      if (widget.onNavigateToLocate != null) {
        widget.onNavigateToLocate!(parkingData);
        showCustomSnackbar(context, "Navigating to locate parking");
      } else {
        showCustomSnackbar(context, "Navigation not available");
      }
    } catch (e) {
      print("Error navigating to locate: $e");
      showCustomSnackbar(context, "Something went wrong. Try again later.");
    }
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
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
          "Parking History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 28),
            onPressed: () {
              setState(() {
                futureParkings = fetchUserParkings();
              });
              showCustomSnackbar(context, "Refreshing History");
            },
          ),
        ],
      ),

      body: SafeArea(
        child: FutureBuilder<List<ParkingSpotModel>>(
          future: futureParkings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print("Firestore Error: ${snapshot.error}");
              return const Center(
                child: Text('App Error: Failed to load data.'),
              );
            }

            final allParkings = snapshot.data ?? [];
            final todayParkings =
                allParkings.where((p) => isToday(p.timestamp)).toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Today's Parking",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Scroll to the All Parking section
                            Scrollable.ensureVisible(
                              _allParkingKey.currentContext!,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.teal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    todayParkings.isEmpty
                        ? const Text("No parking recorded today.")
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: todayParkings.length,
                          itemBuilder: (context, index) {
                            final p = todayParkings[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.local_parking_outlined,
                                  color: Colors.teal,
                                ),
                                title: Text(
                                  "Time: ${DateFormat('HH:mm:ss').format(p.timestamp)}",
                                ),
                                subtitle: Text(
                                  p.note?.trim().isEmpty ?? true
                                      ? "No notes for this parking"
                                      : p.note!,
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: Colors.teal,
                                ),
                                onTap:
                                    () => handleParkingTap(
                                      p,
                                    ), // Add onTap functionality
                              ),
                            );
                          },
                        ),
                    const SizedBox(height: 24),

                    // Add the key here
                    Text(
                      "All Parking",
                      key: _allParkingKey,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: allParkings.length,
                      itemBuilder: (context, index) {
                        final p = allParkings[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.local_parking_outlined,
                              color: Colors.black45,
                            ),
                            title: Text(
                              "Date: ${p.timestamp.toLocal().toString().split(' ')[0]}",
                            ),
                            subtitle: Text(
                              p.note?.trim().isEmpty ?? true
                                  ? "No notes for this parking"
                                  : p.note!,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                            ),
                            onTap:
                                () => handleParkingTap(
                                  p,
                                ), // Add onTap functionality
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
