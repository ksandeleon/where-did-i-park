import 'package:flutter/material.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 50,
        automaticallyImplyLeading: false,
        title: const Text(
          //is it also possible to make an animation here, when the users pulls down the screen, the text will stretch
          "Change this to users location and add some animations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            ),
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
                //implement body


              ],
            ),
          ),
        ),
      ),
    );
  }
}
