import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:sharafai_handson/screens/register_screen.dart';
import 'dart:convert';
import 'courses_screen.dart';
// ==========================================================================
// 1. STATES
// ==========================================================================
abstract class LoginState {}
class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {}
class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}
class LoginInvalid extends LoginState {
  final String? emailError, passwordError;
  LoginInvalid({this.emailError, this.passwordError});
}
// ==========================================================================
// 2. CUBIT
// ==========================================================================
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    // 1. التحقق الشكلي (Validation)
    if (email.isEmpty || password.isEmpty) {
      return emit(
        LoginInvalid(emailError: "Required", passwordError: "Required"),
      );
    }
    final eErr = !email.endsWith('@gmail.com') ? "Invalid Gmail" : null;
    final pErr = password.length < 8 ? "Too Short min(8 chars)" : null;
    if ([eErr, pErr, ].any((e) => e != null)) {
    return emit(LoginInvalid(emailError: eErr, passwordError: pErr));
    }
    emit(LoginLoading());
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/users/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      // Using ternary for success/fail check
      (response.statusCode == 200 || response.statusCode == 201)
          ? emit(LoginSuccess())
          : emit(LoginError('Server Login Failed'));
    } catch (_) {
      emit(LoginError('No Internet Connection'));
    }
  }
}
// ==========================================================================
// 3. SCREEN
// ==========================================================================
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login', style: TextStyle(color: Colors.white)), backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) => switch (state) {
            LoginSuccess() => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CoursesScreen()),
            ),
            LoginError(message: var m) =>
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(m), backgroundColor: Colors.red),
              ),
            _ => null,
          },
          builder: (context, state) {
            final invalid = state is LoginInvalid ? state : null;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_person,
                    size: 100,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(height: 40),
                  _buildField(emailController, 'Email', invalid?.emailError),
                  const SizedBox(height: 20),
                  _buildField(
                    passwordController,
                    'Password',
                    invalid?.passwordError,
                    isPass: true,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200))),
                      onPressed: state is LoginLoading
                          ? null
                          : () => context.read<LoginCubit>().loginUser(
                              emailController.text,
                              passwordController.text,
                            ),
                      child: state is LoginLoading
                          ? const CircularProgressIndicator()
                          : const Text("LOGIN", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(onPressed: () {  
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                  }, child: const Text("Don't have an account? Register", style: TextStyle(color: Colors.blueAccent, fontSize: 16),))
                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildField(
    TextEditingController c,
    String l,
    String? e, {
    bool isPass = false,
  }) => TextFormField(
    controller: c,
    obscureText: isPass,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      labelText: l,
      errorText: e,
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white10,),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  );
}