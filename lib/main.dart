// main.dart

import 'package:flutter/material.dart';
import 'package:football_hero/screens/signup_screen.dart';
import 'package:football_hero/screens/login_screen.dart';
import 'package:football_hero/screens/forgot_password_screen.dart';
import 'package:football_hero/screens/onboarding_screen.dart';
import 'package:football_hero/screens/welcome_screen.dart';
import 'package:football_hero/screens/success_screen.dart';
import 'package:football_hero/screens/onboarding/player_onboarding_screen_1.dart';
import 'package:football_hero/screens/onboarding/parent_onboarding_screen_1.dart';
import 'package:football_hero/screens/onboarding/mentor_onboarding_screen_1.dart';
import 'package:football_hero/screens/onboarding/community_onboarding_screen_1.dart';
import 'package:football_hero/screens/onboarding/coach_onboarding_screen_1.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: "assets/.env");

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );

    runApp(const MyApp());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Initialization error: $e'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Hero',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'VarelaRound',
      ),
      initialRoute: '/onboarding',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/success': (context) => const SuccessScreen(userId: ''),
        '/onboarding': (context) => const OnboardingScreen(userId: ''),
        '/onboarding/player': (context) => const PlayerOnboardingScreen(),
        '/onboarding/parent': (context) => const ParentOnboardingScreen(),
        '/onboarding/mentor': (context) => const MentorOnboardingScreen(),
        '/onboarding/community': (context) => const CommunityOnboardingScreen(),
        '/onboarding/coach': (context) => const CoachOnboardingScreen(),
      },
    );
  }
}
