import 'package:flutter/material.dart';
import 'package:where_did_i_park/home/screens/home_root.dart';
import 'package:where_did_i_park/save-park/screens/save_park_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GO PARKING',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: SaveParkRoot(),
    );
  }
}
