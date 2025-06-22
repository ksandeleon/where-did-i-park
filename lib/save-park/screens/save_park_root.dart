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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Marikina",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_2_outlined, size: 28),
            tooltip: 'Sign In / Sign Up',
            onPressed: () {
              // Navigate to your sign in / sign up screen
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => const ParkingForm()),
              //   );
              // Handle settings navigation here
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('account tapped')));
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
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ParkingForm()),
                    // );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('NavToHistory tapped')),
                    );
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
