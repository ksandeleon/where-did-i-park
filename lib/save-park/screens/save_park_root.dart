import 'package:flutter/material.dart';

class SaveParkRoot extends StatefulWidget {
  const SaveParkRoot({super.key});

  @override
  State<SaveParkRoot> createState() => _SaveParkRootState();
}

class _SaveParkRootState extends State<SaveParkRoot> with SingleTickerProviderStateMixin {
  late AnimationController _refreshController;
  bool _isRefreshing = false;
  double _stretchOffset = 0.0;
  static const double _maxStretch = 100.0; // Maximum stretch before refresh

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate refresh delay - replace with your actual refresh logic
    await Future.delayed(const Duration(seconds: 2));

    // TODO: Add your actual refresh logic here
    // Example: reload data, fetch from API, etc.
    print("Refreshing data...");

    _refreshController.reverse();
    setState(() {
      _isRefreshing = false;
      _stretchOffset = 0.0;
    });
  }

  String _getRefreshText() {
    if (_isRefreshing) return "Refreshing...";
    if (_stretchOffset >= _maxStretch) return "Release to refresh";
    if (_stretchOffset > 0) return "Pull down to refresh";
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollUpdateNotification) {
            // Track stretch amount
            final metrics = notification.metrics;
            if (metrics.pixels < 0) {
              setState(() {
                _stretchOffset = (-metrics.pixels).clamp(0.0, _maxStretch);
              });
            } else if (_stretchOffset > 0) {
              setState(() {
                _stretchOffset = 0.0;
              });
            }
          } else if (notification is ScrollEndNotification) {
            // Handle release
            if (_stretchOffset >= _maxStretch && !_isRefreshing) {
              _handleRefresh();
            }
          }
          return false;
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 50, 
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: null,
                background: Stack(
                  children: [
                    // Fixed background that never moves
                    Container(
                      alignment: Alignment.center,
                      color: Colors.blue[300],
                      child: const Text(
                        "User Location",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Fixed refresh UI overlay
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: AnimatedOpacity(
                        opacity: _stretchOffset > 0 ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isRefreshing)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            else
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  value: _stretchOffset / _maxStretch,
                                  strokeWidth: 2,
                                  backgroundColor: Colors.white30,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              _getRefreshText(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Add button logic
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Body content goes here"),
                    // Add more content to test scrolling
                    ...List.generate(20, (index) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.park),
                            title: Text("Park Item ${index + 1}"),
                            subtitle: const Text("Sample park data"),
                          ),
                        ),
                      ),
                    ),
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
