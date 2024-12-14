import 'package:flutter/material.dart';

class MentorOnboardingScreen extends StatelessWidget {
  const MentorOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ברוך הבא, מנטור!')),
      body: const Center(
        child: Text(
          'השלב הבא למנטורים.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
