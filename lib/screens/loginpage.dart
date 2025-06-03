import 'package:flutter/material.dart';
import 'signuppage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shopify/main.dart';
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHoveringForgot = false;
  bool isHoveringSignup = false;



  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  final _formKey=GlobalKey<FormState>();
  bool isLoading = false;

  
 Future<void> _loginUser() async {
    // Show loading indicator
    setState(() {
      isLoading = true;
    });

    // Get the values from the text controllers
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Basic validation to ensure fields are not empty before sending
    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please enter both email and password.');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      // Use http.post instead of just 'post'
      // Use Uri.parse to convert the URL string into a Uri object
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/signin/'), // Your API login URL
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8', // Tell the API we're sending JSON
        },
        // Encode your data to JSON format
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Login successful!
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Login successful: $responseData');
        _showSnackBar('Login successful!');

        // Navigate to your home screen or dashboard
        // Ensure HomePlaceholderPage exists or replace with your actual home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      } else {
        // Login failed ( invalid credentials, 400 Bad Request)
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        String errorMessage = errorData['error'] ?? 'An unknown error occurred.';
        _showSnackBar('Login failed: $errorMessage');
        print('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Handle network errors (e.g., no internet connection, API not reachable)
      _showSnackBar('Network error: ${e.toString()}');
      print('Error during login: $e');
    } finally {
      // Hide loading indicator regardless of success or failure
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper function to show a SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: screenHeight,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
             
                 Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                    child: Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                   validator: (value) {
                    if (value == null || value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                   validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MouseRegion(
                      onEnter: (_) => setState(() => isHoveringForgot = true),
                      onExit: (_) => setState(() => isHoveringForgot = false),
                      child: GestureDetector(
                        onTap: () {
                          print('Forgot password?');
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            decoration:
                                isHoveringForgot
                                    ? TextDecoration.underline
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                       if (_formKey.currentState!.validate()) {
                          _loginUser();
                          print('Login pressed');
            
                       }
                      },
                     
                   
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account? ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    MouseRegion(
                      onEnter: (_) => setState(() => isHoveringSignup = true),
                      onExit: (_) => setState(() => isHoveringSignup = false),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignupPage()),
                          );
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            decoration:
                                isHoveringSignup
                                    ? TextDecoration.underline
                                    : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
