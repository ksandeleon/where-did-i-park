import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
        duration: const Duration(seconds:1),
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
          "Parking History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 28),
            onPressed: () {
              showCustomSnackbar(context, "Refreshing History");
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Parking",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Placeholder for today's parking list
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2, // replace with your actual data count
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.local_parking_rounded,
                        color: Colors.blueAccent,
                      ),
                      title: Text("Parking Spot #$index"),
                      subtitle: Text("Time: 8:00 AM"),
                      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // All Parking Title
              Text(
                "All Parking",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              // Placeholder for all parking list
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: 5, // replace with your actual data count
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.local_parking_rounded,
                          color: Colors.green,
                        ),
                        title: Text("All Parking Spot #$index"),
                        subtitle: Text("Date: 2025-06-24"),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
