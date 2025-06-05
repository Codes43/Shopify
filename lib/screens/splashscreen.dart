import 'package:flutter/material.dart';
import 'homepage.dart'; 
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomePage after 2 seconds
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Customize background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 185),
              child: Image.asset("assets/splash.png")), // Logo/Icon
            SizedBox(height: 20),
            Container(
              child:Column( children: [ Text(
                'Shopify',
                style: GoogleFonts.inriaSans(color: Colors.black,fontSize: 38,fontWeight: FontWeight.bold)
              
            ),
            Text(
              'online store',
              style: GoogleFonts.inriaSans(fontSize: 25,color: Colors.black38),
            )]))
          ],
        ),
      ),
    );
  }
}
