import 'package:flutter/material.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String role = 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Image.asset('images/sharafai-logo.png', height: 100),
              const SizedBox(height: 40),

              DropdownButtonFormField(
                value: role,
                decoration: _inputDecoration('Role'),
                items: const [
                  DropdownMenuItem(value: 'User', child: Text('User')),
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  setState(() {
                    role = value!;
                  });
                },
              ),

              const SizedBox(height: 20),
              // ---------- Full Name ----------
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (RegExp(r'[0-9]').hasMatch(value)) {
                    return 'Name cannot contain numbers';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              // ---------- Email ----------
              TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (!value.endsWith('@gmail.com')) {
                    return 'Email must end with @gmail.com';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),
              // ---------- Password ----------
              TextFormField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Password'),
                validator: (value) =>
                    value != null && value.length >= 8 ? null : 'Min 8 characters',
              ),

              const SizedBox(height: 20),
              // ---------- Confirm Password ----------
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Confirm Password'),
                validator: (value) =>
                    value == passwordController.text ? null : 'Passwords do not match',
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration successful ✅'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    );
  }
}
