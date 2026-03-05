import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/login_cubit.dart';
import 'courses_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const CoursesScreen()));
            } else if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red));
            }
          },
          builder: (context, state) {
            final invalid = state is LoginInvalid ? state : null;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_person, size: 100, color: Colors.blueAccent),
                  const SizedBox(height: 40),
                  _buildField(emailController, 'Email', invalid?.emailError),
                  const SizedBox(height: 20),
                  _buildField(passwordController, 'Password', invalid?.passwordError, isPass: true),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200))),
                    onPressed: state is LoginLoading
                        ? null
                        : () => context
                            .read<LoginCubit>()
                            .loginUser(emailController.text, passwordController.text),
                    child: state is LoginLoading
                        ? const CircularProgressIndicator()
                        : const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()));
                    },
                    child: const Text("Don't have an account? Register",
                        style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController c, String l, String? e, {bool isPass = false}) =>
      TextFormField(
        controller: c,
        obscureText: isPass,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: l,
          errorText: e,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white10),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
}