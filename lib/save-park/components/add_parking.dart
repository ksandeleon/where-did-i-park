import 'package:flutter/material.dart';

class AddParkingCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddParkingCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(30),
        color: Colors.grey[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 40),
            Icon(
              Icons.add_location_alt,
              size: 120,
              color: Colors.teal,
            ),
            SizedBox(height: 12),
            Text(
              "Click here to add a parking location of your car",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
