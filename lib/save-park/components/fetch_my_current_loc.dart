import 'package:flutter/material.dart';

class FetchCurrentLocation extends StatelessWidget {
  final VoidCallback onTap;
  const FetchCurrentLocation({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24), // Add side padding
      child: SizedBox(
        width: double.infinity, // Full width within padding
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal.shade50,
            foregroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
          ),
          child: const Text(
            "Auto Scan My Location",
            style: TextStyle( fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
