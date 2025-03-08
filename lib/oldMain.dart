import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'screens/signup.dart';
import 'screens/home.dart';
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
import 'state/onboarding_state.dart';
import 'screens/reset_password.dart';
import 'dart:io'; // Add this for printing platform info

// Add a navigator key for GoRouter
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Print debug info to verify platform and context
  debugPrint('===== APP STARTUP DEBUG INFO =====');
  debugPrint('Platform: ${Platform.operatingSystem}');
  debugPrint('App Directory: ${Directory.current.path}');
  debugPrint('=====================================');

  try {
    // Load environment variables with error handling
    String envFile = ".env";
    bool envLoaded = false;

    try {
      await dotenv.load(fileName: envFile);
      envLoaded = true;
    } catch (e) {
      debugPrint('Error loading .env file: $e');
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

    // Validate environment variables
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseAnonKey == null || supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw Exception('Missing or empty Supabase keys in $envFile');
    }

    // Initialize Supabase
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      debug: false,
    );

    runApp(const MyApp());
  } catch (error, stackTrace) {
    debugPrint('Fatal error during app initialization: $error');
    debugPrint('Stack trace: $stackTrace');
    runApp(ErrorApp(error: error.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
      routerConfig: _router,
    );
  }
}

/// ✅ **Configure `go_router` for deep linking**
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: true, // Enable debug logging
  
  // Add an observer for logging
  observers: [
    NavigatorObserver(),
  ],
  
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        debugPrint('Building Welcome screen, URI: ${state.uri}');
        return const Welcome();
      }
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const Signup()
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login()
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPassword()
    ),

    /// 🛠️ **Deep Link Handling for Reset Password**
    GoRoute(
      path: '/reset-password',
      name: 'resetPassword',
      builder: (context, state) {
        debugPrint('Building ResetPassword screen, URI: ${state.uri}');
        debugPrint('Query parameters: ${state.uri.queryParameters}');
        
        final String? token = state.uri.queryParameters['code'];
        if (token != null) {
          debugPrint('Token found: $token');
          return ResetPasswordScreen(accessToken: token);
        } else {
          debugPrint('No token found in parameters');
          return const ErrorScreen(error: "Invalid reset token");
        }
      },
    ),
  ],
  
  // Handle incoming deep links
  redirect: (BuildContext context, GoRouterState state) {
    final uri = state.uri;
    
    // Log ALL the details about the incoming URI
    debugPrint('===== DEEP LINK DEBUG INFO =====');
    debugPrint('Full URI: ${uri.toString()}');
    debugPrint('Scheme: ${uri.scheme}');
    debugPrint('Host: ${uri.host}');
    debugPrint('Path: ${uri.path}');
    debugPrint('Query Parameters: ${uri.queryParameters}');
    debugPrint('Fragment: ${uri.fragment}');
    debugPrint('=================================');
    
    // Handle hoodhero scheme
    if (uri.scheme == 'hoodhero') {
      debugPrint('⭐ Detected hoodhero scheme!');
      
      // For the format hoodhero:/reset-password?code=TOKEN
      if (uri.path == '/reset-password') {
        debugPrint('⭐ Detected /reset-password path!');
        
        final code = uri.queryParameters['code'];
        if (code != null) {
          // Redirect to the reset-password route with the code
          debugPrint('⭐ Found code parameter: $code');
          debugPrint('⭐ Redirecting to /reset-password?code=$code');
          return '/reset-password?code=$code';
        } else {
          debugPrint('❌ No code parameter found');
        }
      } else {
        debugPrint('❌ Path is not /reset-password, it is: ${uri.path}');
      }
    } else {
      debugPrint('❌ Scheme is not hoodhero, it is: ${uri.scheme}');
    }
    
    // No redirection needed for normal routes
    return null;
  },
  
  // This lets us see any errors in routing
  onException: (context, state, exception) {
    debugPrint('❌ GoRouter exception: $exception');
  },
);

/// 🔴 **Error Handling Widget**
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
                  'שגיאה באתחול האפליקציה:', // Hebrew: "Error initializing the app"
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

/// 🔴 **Error Page for Invalid Routes**
class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 18)),
      ),
    );
  }
}