import 'package:flutter/material.dart';
import 'package:shopify/models/product_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteProducts = [];
  // this one helps me list all
  List<Product> get favorites => _favoriteProducts;

  bool isFavorite(Product product) {
    return _favoriteProducts.any((p) => p.id == product.id);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _favoriteProducts.removeWhere((p) => p.id == product.id);
    } else {
      _favoriteProducts.add(product);
    }
    notifyListeners();
  }
}