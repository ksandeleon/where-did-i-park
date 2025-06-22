import 'package:flutter/material.dart';

class ParkingForm extends StatefulWidget {
  const ParkingForm({super.key});

  @override
  State<ParkingForm> createState() => _ParkingFormState();
}

class _ParkingFormState extends State<ParkingForm> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Helper: Calculate dynamic font size based on scroll
  double get _titleFontSize => _scrollOffset < 40 ? 18 : 26;

  // Helper: Show marker only when pulled
  bool get _showLocationRow => _scrollOffset >= 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Custom Sliver App Bar (Not real AppBar)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left column (title + location)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: _titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          child: const Text("Marikina"),
                        ),
                        const SizedBox(height: 4),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child:
                              _showLocationRow
                                  ? Row(
                                    key: const ValueKey('with-icon'),
                                    children: const [
                                      Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Current Location",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  )
                                  : Container(
                                    key: const ValueKey('line'),
                                    height: 2,
                                    width: 60,
                                    color: Colors.grey.shade300,
                                  ),
                        ),
                      ],
                    ),

                    // Right side icons
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.account_circle),
                          onPressed: () {
                            // go to account screen
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            // go to settings
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Body content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    SizedBox(height: 300),
                    Text("Scroll to see header behavior"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
