// lib/screens/mentor_onboarding.dart

import 'package:flutter/material.dart';
import '../../logger/logger.dart';

class MentorOnboarding extends StatefulWidget {
  final String userId;

  const MentorOnboarding({
    super.key,
    required this.userId,
  });

  @override
  State<MentorOnboarding> createState() => _MentorOnboardingState();
}

class _MentorOnboardingState extends State<MentorOnboarding> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    AppLogger.info('Mentor Onboarding initialized with userId: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('הרשמת מנטור'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ברוכים הבאים להרשמת מנטור',
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