import 'package:flutter/material.dart';

class NavToHistory extends StatelessWidget {
  final VoidCallback onTap;

  const NavToHistory({super.key, required this.onTap});

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
            "Go to my previous parking",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
