import 'package:flutter/material.dart';

class LocateParkingRoot extends StatefulWidget {
  const LocateParkingRoot({super.key});

  @override
  State<LocateParkingRoot> createState() => _LocateParkingRootState();
}

class _LocateParkingRootState extends State<LocateParkingRoot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Navigate To Car",
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
        child: Column(
          children: [
            //TODO: waawa
          ],
        ),
      ),
    );
  }
}
