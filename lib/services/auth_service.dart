 import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService with ChangeNotifier {
  String? _token;
  // ignore: unused_field
  String? _refreshToken;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _refreshToken = prefs.getString('refresh_token');
    final userDataString = prefs.getString('user_data');
    
    if (userDataString != null) {
      _userData = jsonDecode(userDataString);
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
  _isLoading = true;
  notifyListeners();
  
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/signin/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final responseData = jsonDecode(response.body);
    
    if (response.statusCode == 200) {
      // Updated to match your actual response structure
      final tokens = responseData['tokens'] as Map<String, dynamic>;
      final accessToken = tokens['access'] as String;
      final refreshToken = tokens['refresh'] as String;
      final user = responseData['user'] as Map<String, dynamic>;
      
      if (accessToken.isEmpty || refreshToken.isEmpty) {
        throw Exception('Tokens are empty');
      }
      
      await _saveAuthData(
        accessToken,
        refreshToken,
        user,
      );
    } else {
      final errorMsg = responseData['message'] ?? 
          'Login failed with status ${response.statusCode}';
      throw Exception(errorMsg);
    }
  } catch (e) {
    await _clearStorage();
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> _saveAuthData(String token, String refreshToken, Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('refresh_token', refreshToken);
    await prefs.setString('user_data', jsonEncode(userData));
    
    _token = token;
    _refreshToken = refreshToken;
    _userData = userData;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    await _clearStorage();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('user_data');
    
    _token = null;
    _refreshToken = null;
    _userData = null;
  }}