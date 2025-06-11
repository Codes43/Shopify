import 'package:flutter/material.dart';
import 'screens/splashscreen.dart'; // Add this
import 'package:provider/provider.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.initialize(); // Initialize auth service
  
  runApp(
    ChangeNotifierProvider(
      create: (context) => authService,
      child: Shopify(),
    ),
  );
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
