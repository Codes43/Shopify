// cartprovider.dart
import 'package:flutter/material.dart';
import 'package:shopify/models/product_model.dart';

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];
  
  List<Product> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;

  Future<void> loadCartItems() async {
    _cartItems = await Product.loadAllProducts();
    notifyListeners();
  }

  Future<void> addToCart(Product product) async {
    await Product.addProdToCart(product); // Make sure this method exists in Product
    await loadCartItems();
  }

  Future<void> removeItem(int productId) async {
    await Product.deleteFromCart(productId);
    await loadCartItems();
  }

  Future<void> clearCart() async {
    await Product.clearAllProducts();
    await loadCartItems();
  }
}