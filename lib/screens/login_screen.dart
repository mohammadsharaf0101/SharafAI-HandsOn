import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'register_screen.dart';
import 'courses_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. GLOBAL KEY: Identifies the form and allows validation of all fields at once.
  final _formKey = GlobalKey<FormState>();

  // 2. STATE VARIABLES: 'isLoading' manages the loading spinner state.
  bool isLoading = false;
  
  // 3. CONTROLLERS: Used to capture and manage user input text.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // 4. AUTHENTICATION LOGIC: Handles API request and form validation.
  Future<void> validateRegister() async {
    // Check if all Form fields pass their validation rules.
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Show loading spinner
      });

      try {
        // API Endpoint for adding/registering a user
        final url = Uri.parse('https://dummyjson.com/users/add');
        
        // Sending POST request with JSON body
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'}, 
          body: json.encode({
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          }),
        );

        setState(() => isLoading = false); // Hide loading spinner

        // Check for successful HTTP response (200 OK or 201 Created)
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            _showSnackBar('Registration Successful! ✅', Colors.green);
            
            // Navigate to Home/Courses and remove Login from the navigation stack
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CoursesScreen()),
            );
          }
        } else {
          // Handle Error response from the server
          final errorData = json.decode(response.body);
          _showSnackBar(
            errorData['message'] ?? 'Registration failed ❌',
            Colors.red,
          );
        }
      } catch (e) {
        // Handle network errors (e.g., no internet)
        setState(() => isLoading = false);
        _showSnackBar('No Internet Connection!', Colors.orange);
      }
    }
  }

  // 5. UTILITY: Helper method to show customized snackbars.
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Connecting the form to the GlobalKey
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.lock_person,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 40),

                // EMAIL INPUT FIELD with validation logic
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email is required';
                    if (!value.endsWith('@gmail.com'))
                      return 'Email must end with @gmail.com';
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                
                // PASSWORD INPUT FIELD with validation logic
                TextFormField(
                  controller: passwordController,
                  obscureText: true, // Hides the characters for security
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password is required';
                    if (value.length < 8)
                      return 'Password must be at least 8 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // LOGIN BUTTON: Switches between Text and Loading Spinner
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : validateRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),

                const SizedBox(height: 15),

                // NAVIGATION to the Register screen
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 6. UI HELPER: Reusable design for the input fields
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}