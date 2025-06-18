import 'dart:convert';
import 'package:shopify/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.category
  });

  String get formattedPrice {
    final NumberFormat formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(price);
  }


  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      id:
          json['id'] is String
              ? int.parse(json['id'])
              : json['id'] as int, // Keep as int
      name: json['name'].toString(),
      price:
          json['price'] is String
              ? double.parse(json['price'])
              : json['price'].toDouble(),
      imageUrl: json['image'],
      description: json['description'].toString(),
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': imageUrl,
      'description': description,
      'category':category
    };
  }

  static Future<void> addProdToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final existingProducts = await _getAllProducts(prefs);

    // Check if product already exists
    final existingIndex = existingProducts.indexWhere(
      (p) => p.id == product.id,
    );

    if (existingIndex >= 0) {
      // Update existing product
      existingProducts[existingIndex] = product;
    } else {
      // Add new product
      existingProducts.add(product);
    }

    await _saveAllProducts(prefs, existingProducts);
  }

  // Delete a product by ID
  static Future<void> deleteFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final products = await _getAllProducts(prefs);

    products.removeWhere((product) => product.id == productId);
    await _saveAllProducts(prefs, products);
  }

  // Delete all products
  static Future<void> clearAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_products');
  }

  // Load all products
  static Future<List<Product>> loadAllProducts() async {
    final prefs = await SharedPreferences.getInstance();

    return await _getAllProducts(prefs);
  }

  // Helper method to get all products
  static Future<List<Product>> _getAllProducts(SharedPreferences prefs) async {
    final jsonString = prefs.getString('cart_products');
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  // Helper method to save all products
  static Future<void> _saveAllProducts(
    SharedPreferences prefs,
    List<Product> products,
  ) async {
    final productJsonList = products.map((p) => p.toJson()).toList();

    await prefs.setString('cart_products', jsonEncode(productJsonList));
  }
}
