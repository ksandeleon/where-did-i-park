import 'package:flutter/material.dart';
import 'package:where_did_i_park/find-my-car/screens/locate_parking_root.dart';
import 'package:where_did_i_park/save-park/screens/save_park_root.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  int _currentIndex = 0;
  Map<String, dynamic>? _initialParkingData;

  final List<String> _labels = ['Parking', 'Locate', 'History'];
  final List<IconData> _icons = [
    Icons.local_parking_outlined,
    Icons.location_searching_outlined,
    Icons.history_outlined,
  ];

  // Method to handle navigation to locate tab with parking data
  void navigateToLocateWithData(Map<String, dynamic> parkingData) {
    setState(() {
      _initialParkingData = parkingData;
      _currentIndex = 1; // Switch to "Locate" tab (index 1)
    });
  }

  List<Widget> get _screens => [
    SaveParkRoot(
      onNavigateToLocate:
          navigateToLocateWithData, // Pass callback to SaveParkRoot too
    ),
    LocateParkingRoot(
      initialParkingData: _initialParkingData,
      key: ValueKey(_initialParkingData), // Force rebuild when data changes
    ),
    SaveParkRoot(
      onNavigateToLocate: navigateToLocateWithData, // Pass callback to history
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_labels.length, (index) {
            final isSelected = _currentIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _currentIndex = index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[index],
                    color: isSelected ? Colors.black87 : Colors.black45,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.black87 : Colors.black45,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
