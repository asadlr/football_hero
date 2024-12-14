import 'package:flutter/material.dart';

class CoachOnboardingScreen extends StatelessWidget {
  const CoachOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ברוך הבא, מאמן!')),
      body: const Center(
        child: Text(
          'השלב הבא למאמן.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
