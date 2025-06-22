import 'package:flutter/material.dart';
import 'package:where_did_i_park/save-park/components/add_parking.dart';

class SaveParkRoot extends StatefulWidget {
  const SaveParkRoot({super.key});

  @override
  State<SaveParkRoot> createState() => _SaveParkRootState();
}

class _SaveParkRootState extends State<SaveParkRoot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 50,
        automaticallyImplyLeading: false,
        title: const Text(
          //is it also possible to make an animation here, when the users pulls down the screen, the text will stretch
          "Marikina",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          //add a add icon addable button here
          //add head icon here representing user actions
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AddParkingCard(onTap: );
                //thinking of adding here components e.g. card 1, 2, 3
              ],
            ),
          ),
        ),
      ),
    );
  }
}
