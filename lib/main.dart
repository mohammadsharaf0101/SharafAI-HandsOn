import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await AuthService.getToken();
  print("TOKEN AT START = $token");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blueAccent,
      ),
    home: const LoginScreen(),sdxxc!  q227      
    );
  }
}