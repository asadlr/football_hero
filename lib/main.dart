import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/onboarding.dart';
import 'screens/signup.dart'; 
import 'screens/login.dart'; 
import 'screens/forgot_password.dart'; 
import 'screens/welcome.dart';  
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://your-supabase-url.supabase.co',
    anonKey: 'your-supabase-anon-key',
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
        fontFamily: 'VarelaRound', // Default font for regular text
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
      locale: const Locale('he', ''), // Default app locale (Hebrew)
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcome(),
        '/signup': (context) => const SignUp(),
        '/login': (context) => const Login(),
        '/forgot-password': (context) => const ForgotPassword(),
        '/onboarding': (context) => const Onboarding(userId: 'temporary-id'),
      },
    );
  }
}
