import 'package:flutter/material.dart';
import 'package:football_hero/screens/signup_screen.dart';
import 'package:football_hero/screens/welcome_screen.dart';
import 'package:football_hero/screens/success_screen.dart'; // Import SuccessScreen from its correct file
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint('Step 1: Loading environment variables...');
    await dotenv.load(fileName: "assets/.env");

    debugPrint('Step 2: Validating environment variables...');
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    if (supabaseUrl == null || supabaseAnonKey == null) {
      throw Exception('Missing SUPABASE_URL or SUPABASE_ANON_KEY in .env file');
    }
    debugPrint('Environment variables loaded successfully.');

    debugPrint('Step 3: Initializing Supabase...');
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    debugPrint('Supabase initialized successfully.');

    debugPrint('Step 4: Running the application...');
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Error during initialization: $e');
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
        fontFamily: 'VarelaRound', // Main font
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const PlaceholderScreen(title: 'Login'),
        '/success': (context) => SuccessScreen(userId: ''), // Correct import
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Screen Placeholder')),
    );
  }
}
