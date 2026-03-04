import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'trainer_home.dart';
import 'trainee_home.dart';
import 'login_screen.dart';
// ==========================================================================
// 1. REGISTER STATES
// ==========================================================================
abstract class RegisterState {}
class RegisterInitial extends RegisterState {}
class RegisterLoading extends RegisterState {}
class RegisterSuccess extends RegisterState { final String role; RegisterSuccess(this.role); }
class RegisterError extends RegisterState { final String message; RegisterError(this.message); }
class RegisterInvalid extends RegisterState {
  final String? nameError, emailError, passwordError, roleError;
  RegisterInvalid({this.nameError, this.emailError, this.passwordError, this.roleError});
}
// ==========================================================================
// 2. REGISTER CUBIT
// ==========================================================================
class RegisterCubit extends Cubit<RegisterState> { 
  RegisterCubit() : super(RegisterInitial());
  Future<void> registerUser({
    required String name, required String email,
    required String password, required String confirmPassword, required String? role,
  }) async {
    // Ternary validation logic
    final nErr = name.isEmpty ? "Name Required" : (RegExp(r'[0-9]').hasMatch(name) ? "Numbers not allowed" : null);
    final eErr = !email.endsWith('@gmail.com') ? "Invalid Gmail" : null;
    final pErr = password.length < 8 ? "Too Short min(8 chars)" : (password != confirmPassword ? "Mismatch" : null);
    final rErr = role == null ? "Select Role" : null;
    // Use a single condition check to trigger the error state
    if ([nErr, eErr, pErr, rErr].any((e) => e != null)) {
      return emit(RegisterInvalid(nameError: nErr, emailError: eErr, passwordError: pErr, roleError: rErr));
    }
    emit(RegisterLoading());
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/users/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'firstName': name, 'email': email, 'password': password, 'role': role}),
      );
      // Using ternary for success/fail check
      (response.statusCode == 200 || response.statusCode == 201)
          ? emit(RegisterSuccess(role!))
          : emit(RegisterError('Server Registration Failed'));
    } catch (_) {
      emit(RegisterError('No Internet Connection'));
    }
  }
}
// ==========================================================================
// 3. REGISTER SCREEN (UI with minimized branching)
// ==========================================================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  String? selectedRole;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  void dispose() {
    for (var c in [nameController, emailController, passwordController, confirmPasswordController]) { c.dispose(); }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
          actions: [
          // 2. LOGOUT ACTION: Navigates back to the previous screen (Login).
          IconButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
        backgroundColor: Colors.black,
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            // Using a pattern matching switch to handle actions
            switch (state) {
              case RegisterSuccess s:
                _showMsg(context, "Success!", Colors.green);
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => s.role == 'Trainer' ? const TrainerHome() : const TraineeHome()
                ));
              case RegisterError e:
                _showMsg(context, e.message, Colors.red);
              default: break;
            }
          },
          builder: (context, state) {
            final invalid = state is RegisterInvalid ? state : null;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                     const Icon(Icons.person_add, size: 100, color: Colors.blueAccent),
                      const SizedBox(height: 40),
                    const SizedBox(height: 40),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDeco('Select Role', invalid?.roleError),
                      items: ['Trainer', 'Trainee'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (v) => setState(() => selectedRole = v),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(controller: nameController, style: const TextStyle(color: Colors.white), decoration: _inputDeco('Full Name', invalid?.nameError)),
                    const SizedBox(height: 16),
                    TextFormField(controller: emailController, style: const TextStyle(color: Colors.white), decoration: _inputDeco('Email', invalid?.emailError)),
                    const SizedBox(height: 16),
                    TextFormField(controller: passwordController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: _inputDeco('Password', invalid?.passwordError)),
                    const SizedBox(height: 16),
                    TextFormField(controller: confirmPasswordController, obscureText: true, style: const TextStyle(color: Colors.white), decoration: _inputDeco('Confirm Password', null)),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: state is RegisterLoading ? null : () => context.read<RegisterCubit>().registerUser(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          confirmPassword: confirmPasswordController.text.trim(),
                          role: selectedRole,
                        ),
                        child: state is RegisterLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('REGISTER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  InputDecoration _inputDeco(String label, String? error) => InputDecoration(
    labelText: label, errorText: error, labelStyle: const TextStyle(color: Colors.white60),
    enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white10), borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.blueAccent), borderRadius: BorderRadius.circular(12)),
    errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.redAccent), borderRadius: BorderRadius.circular(12)),
    focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(12)),
  );
  void _showMsg(BuildContext context, String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m), backgroundColor: c));
}