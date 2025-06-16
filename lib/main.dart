import 'package:flutter/material.dart';
import 'screens/splashscreen.dart'; 
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'package:shopify/provider/cartprovider.dart';
import 'package:shopify/provider/favorites_provider.dart';

// And in providers list:
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  final cartProvider = CartProvider();
  await authService.initialize(); // Initialize auth service
  
  runApp(
    MultiProvider(providers: 
    ///added multiple provider
      [
        ChangeNotifierProvider(create: (_) => authService),
        ChangeNotifierProvider(create: (_) => cartProvider), 
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
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
