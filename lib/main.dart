import 'package:flutter/material.dart';
import 'screens/loginpage.dart';
import 'screens/homepage.dart';
import 'screens/splashscreen.dart'; // Add this

void main() {
  runApp(Shopify());
}

class Shopify extends StatelessWidget {
  const Shopify({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hansu Shopify',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(), // ← Use splash screen here
    );
  }
}
