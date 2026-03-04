import 'package:flutter/material.dart';

// TrainerHome screen
// This screen is displayed after a user registers as a Trainer.
class TrainerHome extends StatelessWidget {
  // Constant constructor for better performance optimization
  const TrainerHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the main layout structure for the screen
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Trainer Home'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}