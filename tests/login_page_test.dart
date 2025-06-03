import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('Login API Tests', () {
    final String baseUrl = 'http://10.0.2.2:8000'; 

    test('Successful login with valid credentials', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/signin/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': 'waneroba@gmail.com', 
          'password': 'password123', 
        }),
      );

      expect(response.statusCode, 200);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      expect(responseData['message'], 'Login successful'); 
    });

    test('Failed login with invalid password', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/signin/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': 'waneroba22@gmail.com', 
          'password': '2211', 
        }),
      );

      expect(response.statusCode, 400); 
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      expect(errorData['error'], 'Invalid credentials'); 
    });

    test('Failed login with non-existent email', () async {
      final response = await http.post(
        Uri.parse('$baseUrl/signin/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': 'nonexistent@example.com', 
          'password': 'password123',
        }),
      );

      expect(response.statusCode, 400); 
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      expect(errorData['error'], 'User not found');
    });

   
    });
  
}