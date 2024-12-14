import 'package:flutter/material.dart';

class CommunityOnboardingScreen extends StatelessWidget {
  const CommunityOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ברוכים הבאים, לצוות הקהילה!')),
      body: const Center(
        child: Text(
          'השלב הבא לצוות הקהילה.',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
