import 'package:flutter/material.dart';
import 'screens/splashscreen.dart'; // Add this
import 'package:http/http.dart' as http;

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
