import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ParkingCarousel extends StatefulWidget {
  const ParkingCarousel({super.key});

  @override
  State<ParkingCarousel> createState() => _ParkingCarouselState();
}

class _ParkingCarouselState extends State<ParkingCarousel> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> parkingTips = [
    {
      "icon": Icons.umbrella,
      "title": "Weather Check",
      "description": "Avoid parking under trees during storms or heavy rain.",
    },
    {
      "icon": Icons.lightbulb_outline,
      "title": "Headlights Off",
      "description": "Don’t forget to turn off your headlights before leaving.",
    },
    {
      "icon": Icons.lock,
      "title": "Lock Your Car",
      "description": "Always double-check that your doors are locked.",
    },
    {
      "icon": Icons.timer,
      "title": "Set a Timer",
      "description": "Set a timer to avoid overstaying in paid parking areas.",
    },
    {
      "icon": Icons.location_on,
      "title": "Remember Location",
      "description": "Use your Go Parking to mark your parking spot.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: parkingTips.length,
          itemBuilder: (context, index, realIndex) {
            final tip = parkingTips[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(tip["icon"], size: 24, color: Colors.black87),
                      SizedBox(width: 4,),
                      Expanded(
                        child: Text(
                          tip["title"],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(right: 32),
                    child: Text(
                      tip["description"],
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 130,
            viewportFraction: 0.9,
            autoPlay: true,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            parkingTips.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.black87 : Colors.black26,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
