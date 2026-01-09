import 'package:climate_sense/screens/signin_screen.dart';
import 'package:climate_sense/screens/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: WelcomeScreen(),
    );
    // return MaterialApp(home: SignInScreen());
  }
}
