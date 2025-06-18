import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify/screens/ShoppingCartScreen.dart';

class PlaceOrderPage extends StatefulWidget {
  const PlaceOrderPage({super.key});

  @override
  _PlaceOrderPageState createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Place Order')),
      body: Center(child: Text('Order Summary')),
    );
  }
}
