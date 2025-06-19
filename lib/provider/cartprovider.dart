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
    // Check if product already exists in cart
    final existingIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingIndex >= 0) {
      // If exists, increase quantity
      await updateItemQuantity(
        product.id,
        _cartItems[existingIndex].quantity + 1,
      );
    } else {
      // If new, add to cart with quantity 1
      final newProduct = product.copyWith(quantity: 1);
      await Product.addProdToCart(newProduct);
      await loadCartItems();
    }
  }

  Future<void> removeItem(int productId) async {
    await Product.deleteFromCart(productId);
    await loadCartItems();
  }

  Future<void> updateItemQuantity(int productId, int newQuantity) async {
    if (newQuantity <= 0) {
      // If quantity is 0 or negative, remove the item
      await removeItem(productId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      final updatedProduct = _cartItems[index].copyWith(quantity: newQuantity);
      await Product.updateCartItem(updatedProduct);
      await loadCartItems();
    }
  }

  Future<void> clearCart() async {
    await Product.clearAllProducts();
    await loadCartItems();
  }

  double get subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }
}
