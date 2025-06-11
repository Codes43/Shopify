import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopify/models/product_model.dart';

class ProductService {
  //final String _baseUrl = 'http://10.0.2.2:8000/products/';

  final String _baseUrl = 'http://127.0.0.1:8000/products/';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        print('API Response Status: ${response.statusCode}');
        print('API Response Body Length: ${response.body.length} bytes');

        List<dynamic> productJson = json.decode(response.body);

        // Map each JSON map to a Product object using the fromJson factory
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load products. Status Code: ${response.statusCode}');
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
