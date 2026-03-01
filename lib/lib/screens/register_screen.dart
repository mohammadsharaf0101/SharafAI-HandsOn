import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'courses_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. FORM KEY: Essential for validating the entire form.
  final _formKey = GlobalKey<FormState>();

  // 2. STATE & CONTROLLERS: 'isLoading' tracks API progress. 
  // Controllers manage and store the user's input.
  bool isLoading = false;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // 3. REGISTRATION LOGIC: Handles form validation and the network request.
  Future<void> validateRegister() async {
    // Check if all text fields meet the validation criteria.
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true; // Start showing the loading spinner.
      });

      try {
        // API Endpoint for adding a new user.
        final url = Uri.parse('https://dummyjson.com/users/add');
        
        // Sending a POST request with the user data.
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'}, 
          body: json.encode({
            'firstName': nameController.text.trim(), 
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          }),
        );

        setState(() => isLoading = false); // Stop the loading spinner.

        // Check for success (Status codes 200 or 201).
        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            _showSnackBar('Registration Successful! ✅', Colors.green);
            
            // Navigate to the next screen and remove the current one from history.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CoursesScreen()),
            );
          }
        } else {
          // Parse and show error messages from the server.
          final errorData = json.decode(response.body);
          _showSnackBar(
            errorData['message'] ?? 'Registration failed ❌',
            Colors.red,
          );
        }
      } catch (e) {
        // Catch network or unexpected errors.
        setState(() => isLoading = false);
        _showSnackBar('No Internet Connection!', Colors.orange);
      }
    }
  }

  // 4. SNACKBAR HELPER: A reusable function to display messages to the user.
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
        title: const Text('Create Account'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey, // Link the form to the _formKey.
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(
                  Icons.person_add,
                  size: 100,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 40),

                // FULL NAME FIELD with Regex validation (Letters only).
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Full Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Name is required';
                    if (RegExp(r'[0-9]').hasMatch(value)) return 'Numbers not allowed';
                    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(value)) {
                      return 'Only letters are allowed';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // EMAIL FIELD with specific domain validation.
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Email is required';
                    if (!value.endsWith('@gmail.com')) return 'Must end with @gmail.com';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // PASSWORD FIELD: Minimum 8 characters.
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Password'),
                  validator: (value) => value != null && value.length >= 8
                      ? null
                      : 'Min 8 characters',
                ),
                const SizedBox(height: 20),

                // CONFIRM PASSWORD: Must match the original password field.
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Confirm Password'),
                  validator: (value) => value == passwordController.text
                      ? null
                      : 'Passwords do not match',
                ),
                const SizedBox(height: 30),

                // REGISTER BUTTON: Toggles between text and spinner based on 'isLoading'.
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : validateRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 5. DECORATION HELPER: Centralizes the styling for all input fields.
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
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}