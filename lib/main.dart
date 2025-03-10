import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
import 'theme/app_theme.dart'; // Import the centralized theme

// Add a navigator key for GoRouter
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables with error handling
    String envFile = ".env";
    bool envLoaded = false;

    try {
      await dotenv.load(fileName: envFile);
      envLoaded = true;
    } catch (e) {
      debugPrint('Error loading .env file');
      try {
        envFile = "assets/.env";
        await dotenv.load(fileName: envFile);
        envLoaded = true;
      } catch (e) {
        debugPrint('Error loading alternate .env file');
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
      debug: kDebugMode,
    );

    runApp(const MyApp());
  } catch (error) {
    debugPrint('Fatal error during app initialization');
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
      theme: AppTheme.theme, // Use the centralized theme system
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

/// Configure `go_router` for all routes including deep linking
final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  debugLogDiagnostics: kDebugMode,
  
  routes: [
    // Basic routes
    GoRoute(
      path: '/',
      builder: (context, state) => const Welcome()
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
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        final userId = args?['userId'] as String? ?? 
                       Supabase.instance.client.auth.currentUser?.id ?? '';
        return HomeScreen(userId: userId);
      }
    ),

    // Reset Password route for deep linking
    GoRoute(
      path: '/reset-password',
      name: 'resetPassword',
      builder: (context, state) {
        final String? token = state.uri.queryParameters['code'];
        if (token != null) {
          return ResetPasswordScreen(accessToken: token);
        } else {
          return const ErrorScreen(error: "Invalid reset token");
        }
      },
    ),
    
    // Onboarding routes
    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const ErrorScreen(error: "Missing onboarding arguments");
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return const ErrorScreen(error: "Invalid user ID");
        }
        
        return Onboarding(
          userId: userId,
          onboardingState: onboardingState ?? const OnboardingState.empty(),
        );
      },
    ),
    GoRoute(
      path: '/onboarding/player',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const ErrorScreen(error: "Missing player onboarding arguments");
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return const ErrorScreen(error: "Invalid user ID");
        }
        
        return PlayerOnboarding(
          userId: userId,
          onboardingState: onboardingState ?? const OnboardingState.empty(),
        );
      },
    ),
    GoRoute(
      path: '/onboarding/parent',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const ErrorScreen(error: "Missing parent onboarding arguments");
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return const ErrorScreen(error: "Invalid user ID");
        }
        
        return ParentOnboarding(
          userId: userId,
          onboardingState: onboardingState ?? const OnboardingState.empty(),
        );
      },
    ),
    GoRoute(
      path: '/onboarding/coach',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const ErrorScreen(error: "Missing coach onboarding arguments");
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return const ErrorScreen(error: "Invalid user ID");
        }
        
        return CoachOnboarding(
          userId: userId,
          onboardingState: onboardingState ?? const OnboardingState.empty(),
        );
      },
    ),
    GoRoute(
      path: '/onboarding/mentor',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const ErrorScreen(error: "Missing mentor onboarding arguments");
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return const ErrorScreen(error: "Invalid user ID");
        }
        
        return MentorOnboarding(
          userId: userId,
          onboardingState: onboardingState ?? const OnboardingState.empty(),
        );
      },
    ),
    GoRoute(
      path: '/onboarding/community',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const ErrorScreen(error: "Missing community onboarding arguments");
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return const ErrorScreen(error: "Invalid user ID");
        }
        
        return CommunityManagerOnboarding(
          userId: userId,
          onboardingState: onboardingState ?? const OnboardingState.empty(),
        );
      },
    ),
    GoRoute(
      path: '/onboarding/favorites',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        if (args == null) {
          return const ErrorScreen(error: "Missing favorites arguments");
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return const ErrorScreen(error: "Invalid user ID");
        }
        
        return FavoritesScreen(
          userId: userId,
          onboardingState: onboardingState ?? const OnboardingState.empty(),
        );
      },
    ),
  ],
  
  // Handle incoming deep links
  redirect: (BuildContext context, GoRouterState state) {
    final uri = state.uri;
    
    // Handle app scheme (hoodhero or footballhero)
    if (uri.scheme == 'hoodhero' || uri.scheme == 'footballhero') {
      // For the format hoodhero:/reset-password?code=TOKEN
      if (uri.path == '/reset-password') {
        final code = uri.queryParameters['code'];
        if (code != null) {
          // Redirect to the reset-password route with the code
          return '/reset-password?code=$code';
        }
      }
    }
    
    // No redirection needed for normal routes
    return null;
  },
  
  // This lets us see any errors in routing
  onException: (context, state, exception) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation error: $exception'),
        backgroundColor: Colors.red,
      ),
    );
  },
);

/// Error Handling Widget for app initialization errors
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.theme, // Use the centralized theme here too
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

/// Error Screen for invalid routes
class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          error, 
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red),
        ),
      ),
    );
  }
}