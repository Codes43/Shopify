import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 1, // Added quantity with default value 1
  });

  // Add copyWith method for immutability
  Product copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      name: json['name'].toString(),
      price:
          json['price'] is String
              ? double.parse(json['price'])
              : json['price'].toDouble(),
      imageUrl: json['image'].replaceFirst('http://', 'https://'),
      description: json['description'].toString(),
      quantity: json['quantity'] ?? 1, // Added quantity parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': imageUrl,
      'description': description,
      'quantity': quantity, // Added quantity to JSON
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
      // If exists, increment quantity
      existingProducts[existingIndex] = existingProducts[existingIndex]
          .copyWith(
            quantity:
                existingProducts[existingIndex].quantity + product.quantity,
          );
    } else {
      // Add new product
      existingProducts.add(product);
    }

    await _saveAllProducts(prefs, existingProducts);
  }

  static Future<void> updateCartItem(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final existingProducts = await _getAllProducts(prefs);

    final existingIndex = existingProducts.indexWhere(
      (p) => p.id == product.id,
    );

    if (existingIndex >= 0) {
      existingProducts[existingIndex] = product;
      await _saveAllProducts(prefs, existingProducts);
    }
  }

  static Future<void> deleteFromCart(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final products = await _getAllProducts(prefs);

    products.removeWhere((product) => product.id == productId);
    await _saveAllProducts(prefs, products);
  }

  static Future<void> clearAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_products');
  }

  static Future<List<Product>> loadAllProducts() async {
    final prefs = await SharedPreferences.getInstance();
    return await _getAllProducts(prefs);
  }

  static Future<List<Product>> _getAllProducts(SharedPreferences prefs) async {
    final jsonString = prefs.getString('cart_products');
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  static Future<void> _saveAllProducts(
    SharedPreferences prefs,
    List<Product> products,
  ) async {
    final productJsonList = products.map((p) => p.toJson()).toList();
    await prefs.setString('cart_products', jsonEncode(productJsonList));
  }
}
