import "package:flutter/material.dart";

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => ClimateWelcomeScreenState();
}

class ClimateWelcomeScreenState extends State<WelcomeScreen> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Title(
              color: Colors.blue,
              child: const Text(
                "Welcome to Climate Sense",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isClicked ? Colors.green : Colors.blue,
            ),
            onPressed: () {
              setState(() {
                isClicked = isClicked ? false : true;
              });
            },
            child: const Text("Click Me"),
          ),
        ],
      ),
    );
  }
}
