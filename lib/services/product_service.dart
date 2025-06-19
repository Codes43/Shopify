import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopify/models/product_model.dart';

class ProductService {

  final String _baseUrl = 'https://shopifyapi-tx6d.onrender.com';

  Future<List<Product>> getProducts() async {
    String url = '$_baseUrl/products/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('API Response Status: ${response.statusCode}');
        print('API Response Status: ${response.body}');

        List<dynamic> productJson = json.decode(response.body);

        // Map each JSON map to a Product object using the fromJson factory
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load products. Status Code: ${response.statusCode}');
        throw Exception(
          'Failed to load products: Server returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
          'Network error: Could not connect to the server. Is your API running and URL correct?',
        );
      } else if (e is FormatException) {
        throw Exception(
          'Failed to parse data. The API returned invalid JSON or its structure doesn\'t match the Product model.',
        );
      } else {
        throw Exception(
          'An unexpected error occurred while fetching products.',
        );
      }
    }
  }

//handle the cart 

  Future<List<Product>> getProductsByCategory(String category) async {
    
    String url;
    if (category == 'All') {
      url = '$_baseUrl/products/';
    } else {
      url = '$_baseUrl/products/?category=$category';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> productJson = json.decode(response.body);
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products for category $category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }


Future<Product> getProduct(pId) async {

    try {
      final response = await http.get(Uri.parse(_baseUrl + pId));

      if (response.statusCode == 200) {
        print('API Response Status: ${response.statusCode}');
        print('API Response Body Length: ${response.body.length} bytes');

        Product productJson = json.decode(response.body);

        // Map each JSON map to a Product object using the fromJson factory
        return productJson;
      } else {
        print('Failed to load product. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
          'Failed to load products: Server returned status ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is http.ClientException) {
        print('Error fetching products (Network Issue): $e');
        throw Exception(
          'Network error: Could not connect to the server. Is your API running and URL correct?',
        );
      } else if (e is FormatException) {
        print('Error fetching products (JSON Parsing Issue): $e');
        throw Exception(
          'Failed to parse data. The API returned invalid JSON or its structure doesn\'t match the Product model.',
        );
      } else {
        print('Error fetching products (Generic): $e');
        throw Exception(
          'An unexpected error occurred while fetching products.',
        );
      }
    }
  }

}
class ProductSearchService {
  final String baseUrl = 'https://shopifyapi-tx6d.onrender.com';


  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/search/?search=$query'),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
