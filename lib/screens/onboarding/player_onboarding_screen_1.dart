import 'package:flutter/material.dart';

class PlayerOnboardingScreen extends StatelessWidget {
  const PlayerOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ברוכים הבאים, שחקן!')),
      body: const Center(
        child: Text(
          'השלב הבא לשחקנים.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
