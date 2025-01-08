import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/signup.dart';
import 'screens/login.dart';
import 'screens/forgot_password.dart';
import 'screens/onboarding.dart';
import 'screens/onboarding/player_onboarding.dart';
import 'screens/onboarding/parent_onboarding.dart';
import 'screens/onboarding/coach_onboarding.dart';
import 'screens/onboarding/community_onboarding.dart';
import 'screens/onboarding/mentor_onboarding.dart';
import 'screens/onboarding/favorites.dart';
import 'screens/welcome.dart';

Future<void> main() async {
  // Ensure proper widget initialization
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables with explicit error handling
    String envFile = ".env";
    bool envLoaded = false;
    
    try {
      await dotenv.load(fileName: envFile);
      envLoaded = true;
    } catch (e) {
      debugPrint('Error loading .env file: $e');
      // Try loading from a different location or with different name
      try {
        envFile = "assets/.env";
        await dotenv.load(fileName: envFile);
        envLoaded = true;
      } catch (e) {
        debugPrint('Error loading alternate .env file: $e');
      }
    }

    if (!envLoaded) {
      throw Exception('Failed to load environment variables');
    }

    // Validate environment variables with detailed error messages
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (supabaseUrl == null) {
      throw Exception('SUPABASE_URL not found in $envFile');
    }
    if (supabaseAnonKey == null) {
      throw Exception('SUPABASE_ANON_KEY not found in $envFile');
    }
    if (supabaseUrl.isEmpty) {
      throw Exception('SUPABASE_URL is empty in $envFile');
    }
    if (supabaseAnonKey.isEmpty) {
      throw Exception('SUPABASE_ANON_KEY is empty in $envFile');
    }

    // Initialize Supabase with timeout
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false, // Disable debug mode in production
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Supabase initialization timed out');
      },
    );

    // Run the app
    runApp(const MyApp());
  } catch (error, stackTrace) {
    debugPrint('Fatal error during app initialization: $error');
    debugPrint('Stack trace: $stackTrace');
    runApp(ErrorApp(error: error.toString()));
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'שגיאה באתחול האפליקציה:',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Hero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'VarelaRound',
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      supportedLocales: const [
        Locale('he', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('he', ''),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        debugPrint('Generating route for: ${settings.name}');
        
          if (settings.name == '/onboarding') {
            final Map<String, dynamic>? args;
            if (settings.arguments is Map<String, dynamic>) {
              args = settings.arguments as Map<String, dynamic>;
            } else {
              debugPrint('Invalid arguments type for onboarding route');
              return MaterialPageRoute(
                builder: (context) => const ErrorApp(
                  error: 'Invalid arguments provided',
                ),
              );
            }

            final userId = args?['userId'] as String?;
            if (userId == null) {
              return MaterialPageRoute(
                builder: (context) => const ErrorApp(
                  error: 'Invalid user ID provided',
                ),
              );
            }

            return MaterialPageRoute(
              builder: (context) => Onboarding(userId: userId),  // Fixed: pass userId directly
              settings: settings,
            );
          }

          // Handle other routes
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const Welcome());
            case '/signup':
              return MaterialPageRoute(builder: (context) => const Signup());
            case '/login':
              return MaterialPageRoute(builder: (context) => const Login());
            case '/forgot-password':
              return MaterialPageRoute(builder: (context) => const ForgotPassword());
            case '/onboarding/player':
              return MaterialPageRoute(
                builder: (context) => const PlayerOnboarding(),
                settings: settings,
              );
            case '/onboarding/favorites':
              return MaterialPageRoute(
                builder: (context) => const Favorites(),
                settings: settings,
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const ErrorApp(
                  error: 'Route not found',
                ),
              );
          }
        },
    );
  }
}