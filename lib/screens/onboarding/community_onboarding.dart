// lib/screens/community_onboarding.dart

import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import '../../state/onboarding_state.dart';

class CommunityOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;

  const CommunityOnboarding({
    super.key,
    required this.userId,
    required this.onboardingState,
  });

  @override
  State<CommunityOnboarding> createState() => _CommunityOnboardingState();
}

class _CommunityOnboardingState extends State<CommunityOnboarding> {
  late String userId;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    AppLogger.info('Community Onboarding initialized with userId: $userId');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('הרשמת צוות קהילתי'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ברוכים הבאים להרשמת צוות קהילתי',
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