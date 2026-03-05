import 'package:flutter/material.dart';

// TraineeHome screen
// This screen appears after a user registers as a Trainee.
class TraineeHome extends StatelessWidget {
  // Constructor with a constant key
  const TraineeHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the basic visual structure of the screen
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Trainee Home'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}