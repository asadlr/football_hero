import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/signup.dart';
import 'screens/login.dart';
import 'screens/forgot_password.dart';
import 'screens/onboarding.dart';
import 'screens/onboarding/player_onboarding1.dart';
import 'screens/onboarding/parent_onboarding1.dart';
import 'screens/onboarding/coach_onboarding1.dart';
import 'screens/onboarding/community_onboarding1.dart';
import 'screens/onboarding/mentor_onboarding1.dart';
import 'screens/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase with values from .env
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
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
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('he', ''), // Hebrew
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('he', ''), // Set the default locale to Hebrew
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcome(),
        '/signup': (context) => const Signup(),
        '/login': (context) => const Login(),
        '/forgot-password': (context) => const ForgotPassword(),
        '/onboarding': (context) => Onboarding(
          userId: ModalRoute.of(context)!.settings.arguments as String
        ),
        '/onboarding/player': (context) => const PlayerOnboarding1(),
        '/onboarding/parent': (context) => const ParentOnboarding1(),
        '/onboarding/coach': (context) => const CoachOnboarding1(),
        '/onboarding/community': (context) => const CommunityOnboarding1(),
        '/onboarding/mentor': (context) => const MentorOnboarding1(),
      },
    );
  }
}
