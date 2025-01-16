// lib/screens/parent_onboarding.dart

import 'package:flutter/material.dart';
import '../../logger/logger.dart';

class ParentOnboarding extends StatefulWidget {
  final String userId;

  const ParentOnboarding({
    super.key,
    required this.userId,
  });

  @override
  State<ParentOnboarding> createState() => _ParentOnboardingState();
}

class _ParentOnboardingState extends State<ParentOnboarding> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    AppLogger.info('Parent Onboarding initialized with userId: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('הרשמת הורה'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ברוכים הבאים להרשמת הורה',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'מזהה משתמש: $userId',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Navigate to next screen or process
                  Navigator.pushNamed(
                    context,
                    '/onboarding/favorites',
                    arguments: {'userId': userId},
                  );
                },
                child: const Text('המשך'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}