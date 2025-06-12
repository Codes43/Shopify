import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopify/models/product_model.dart'; 

class ProductService {
  //final String _baseUrl = 'http://10.0.2.2:8000/products/';

  final String _baseUrl = 'http://10.0.2.2:8000/products/';
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        print('API Response Status: ${response.statusCode}');

        List<dynamic> productJson = json.decode(response.body);

        // Map each JSON map to a Product object using the fromJson factory
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load products. Status Code: ${response.statusCode}');
        throw Exception('Failed to load products: Server returned status ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network error: Could not connect to the server. Is your API running and URL correct?');
      } else if (e is FormatException) {
        throw Exception('Failed to parse data. The API returned invalid JSON or its structure doesn\'t match the Product model.');
      } else {
        throw Exception('An unexpected error occurred while fetching products.');
      }
    }
  }
}


class ProductSearchService {
  final String baseUrl = 'http://10.0.2.2:8000'; 

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