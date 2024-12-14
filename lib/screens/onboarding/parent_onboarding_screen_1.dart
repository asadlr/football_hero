import 'package:flutter/material.dart';

class ParentOnboardingScreen extends StatelessWidget {
  const ParentOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ברוכים הבאים, הורה!')),
      body: const Center(
        child: Text(
          'השלב הבא להורים.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
