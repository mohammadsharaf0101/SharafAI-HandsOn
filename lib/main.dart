import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

// 1. ENTRY POINT: The main function is where the app starts executing.
void main() {
  runApp(MyApp());
}

// 2. ROOT WIDGET: MyApp is the base of your entire application widget tree.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 3. MATERIAL APP: The wrapper for core features like Navigation, Themes, and Locales.
    return MaterialApp(
      // Removes the "Debug" banner from the top-right corner.
      debugShowCheckedModeBanner: false,
      
      // 4. HOME PROPERTY: Defines the first screen the user sees when opening the app.
      home: LoginScreen(),
    );
  }
}
