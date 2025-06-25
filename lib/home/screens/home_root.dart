import 'package:flutter/material.dart';
import 'package:where_did_i_park/find-my-car/screens/locate_parking_root.dart';
import 'package:where_did_i_park/park-history/screens/history_screen.dart';
import 'package:where_did_i_park/save-park/screens/save_park_root.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> with TickerProviderStateMixin {
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

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _screens => [
    SaveParkRoot(
      key: const ValueKey('save_park'),
      onNavigateToLocate: navigateToLocateWithData,
    ),
    LocateParkingRoot(
      key: ValueKey('locate_${_initialParkingData?.hashCode ?? 'default'}'),
      initialParkingData: _initialParkingData,
    ),
    HistoryScreen(
      key: const ValueKey('history'),
      onNavigateToLocate: navigateToLocateWithData,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 400,
        ), // Slightly longer for smooth swipe
        transitionBuilder: (Widget child, Animation<double> animation) {
          // Always slide from right to left (forward direction only)
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), // Always slide from right
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic, // Smooth easing curve
              ),
            ),
            child: child,
          );
        },
        child: _screens[_currentIndex],
      ),
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
              onTap: () => _onTabTapped(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? Colors.black.withOpacity(0.05)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _icons[index],
                        color: isSelected ? Colors.black87 : Colors.black45,
                        size: isSelected ? 26 : 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: isSelected ? Colors.black87 : Colors.black45,
                        fontSize: isSelected ? 13 : 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      child: Text(_labels[index]),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
