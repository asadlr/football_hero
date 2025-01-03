import 'package:flutter/material.dart';

class ParentOnboarding1 extends StatelessWidget {
  const ParentOnboarding1({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final userId = args?['userId'];
    final role = args?['role'];

    return Scaffold(
      appBar: AppBar(title: const Text('Player Onboarding')),
      body: Center(
        child: Text('Welcome Player! User ID: $userId, Role: $role'),
      ),
    );
  }
}
