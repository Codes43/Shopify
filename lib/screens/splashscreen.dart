import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.white, // Customize background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.only(top: 185),
              child: Image.asset("assets/splash.png"),
            ), // Logo/Icon
            SizedBox(height: 20),
            Container(
              child: Column(
                children: [
                  Text(
                    'Shopify',
                    style: GoogleFonts.inriaSans(
                      color: Colors.black,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),

                  Text(
                    'online store',
                    style: GoogleFonts.inriaSans(
                      fontSize: 25,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
=======
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                          "assets/splash.png",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.shopping_cart, size: 100),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            'Shopify',
                            style: GoogleFonts.inriaSans(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'online store',
                            style: GoogleFonts.inriaSans(
                              fontSize: 25,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
>>>>>>> 191ad356187dfc83e180048b8edbb0fefe91abf7
