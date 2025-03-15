import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import all screens
import '../screens/signup.dart';
import '../screens/home.dart';
import '../screens/login.dart';
import '../screens/forgot_password.dart';
import '../screens/onboarding.dart';
import '../screens/reset_password.dart';
import '../screens/onboarding/player_onboarding.dart';
import '../screens/onboarding/parent_onboarding.dart';
import '../screens/onboarding/coach_onboarding.dart';
import '../screens/onboarding/community_onboarding.dart';
import '../screens/onboarding/mentor_onboarding.dart';
import '../screens/onboarding/favorites.dart';
import '../screens/welcome.dart';
import '../state/onboarding_state.dart';
import '../utils/error_handler.dart';
import '../services/navigation_service.dart'; // Add this import

class AppRouterConfig {
  // Navigator key for global navigation - use the same key as NavigationService
  static final GlobalKey<NavigatorState> _rootNavigatorKey = 
      NavigationService.navigatorKey;

  /// Configured router with all application routes
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    
    routes: [
      // Basic routes with transitions
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Welcome(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Signup(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const Login(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPassword(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          final userId = _extractUserId(state);
          return CustomTransitionPage(
            key: state.pageKey,
            child: HomeScreen(userId: userId),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),

      // Reset Password route for deep linking
      GoRoute(
        path: '/reset-password',
        name: 'resetPassword',
        pageBuilder: (context, state) {
          final String? token = state.uri.queryParameters['code'];
          return CustomTransitionPage(
            key: state.pageKey,
            child: token != null 
              ? ResetPasswordScreen(accessToken: token)
              : ErrorHandler.createErrorScreen("Invalid reset token"),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      
      // Onboarding routes with shared logic
      ..._createOnboardingRoutes(),
    ],
    
    // Handle deep linking
    redirect: _handleDeepLinks,
    
    // Error handling for navigation
    errorPageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: ErrorHandler.createErrorScreen("Navigation error"),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  );

  /// Create onboarding routes with shared configuration
  static List<GoRoute> _createOnboardingRoutes() {
    return [
      _createOnboardingRoute('/onboarding', 
        (userId, onboardingState) => Onboarding(
          userId: userId, 
          onboardingState: onboardingState ?? const OnboardingState.empty()
        )
      ),
      _createOnboardingRoute('/onboarding/player', 
        (userId, onboardingState) => PlayerOnboarding(
          userId: userId, 
          onboardingState: onboardingState ?? const OnboardingState.empty()
        )
      ),
      _createOnboardingRoute('/onboarding/parent', 
        (userId, onboardingState) => ParentOnboarding(
          userId: userId, 
          onboardingState: onboardingState ?? const OnboardingState.empty()
        )
      ),
      _createOnboardingRoute('/onboarding/coach', 
        (userId, onboardingState) => CoachOnboarding(
          userId: userId, 
          onboardingState: onboardingState ?? const OnboardingState.empty()
        )
      ),
      _createOnboardingRoute('/onboarding/mentor', 
        (userId, onboardingState) => MentorOnboarding(
          userId: userId, 
          onboardingState: onboardingState ?? const OnboardingState.empty()
        )
      ),
      _createOnboardingRoute('/onboarding/community', 
        (userId, onboardingState) => CommunityManagerOnboarding(
          userId: userId, 
          onboardingState: onboardingState ?? const OnboardingState.empty()
        )
      ),
      _createOnboardingRoute('/onboarding/favorites', 
        (userId, onboardingState) => FavoritesScreen(
          userId: userId, 
          onboardingState: onboardingState ?? const OnboardingState.empty()
        )
      ),
    ];
  }

  /// Generic onboarding route creator - updated for transitions
  static GoRoute _createOnboardingRoute(
    String path, 
    Widget Function(String userId, OnboardingState? onboardingState) screenBuilder
  ) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) {
        final args = state.extra as Map<String, dynamic>?;
        
        if (args == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ErrorHandler.createErrorScreen("Missing onboarding arguments"),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        
        final userId = args['userId'] as String?;
        final onboardingState = args['onboardingState'] as OnboardingState?;
        
        if (userId == null) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ErrorHandler.createErrorScreen("Invalid user ID"),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        }
        
        return CustomTransitionPage(
          key: state.pageKey,
          child: screenBuilder(userId, onboardingState),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
      },
    );
  }

  /// Extract user ID from router state
  static String _extractUserId(GoRouterState state) {
    final args = state.extra as Map<String, dynamic>?;
    return args?['userId'] as String? ?? 
           Supabase.instance.client.auth.currentUser?.id ?? 
           '';
  }

  /// Handle deep linking
  static String? _handleDeepLinks(BuildContext context, GoRouterState state) {
    final uri = state.uri;
    
    // Handle app scheme (hoodhero or footballhero)
    if ((uri.scheme == 'hoodhero' || uri.scheme == 'footballhero') &&
        uri.path == '/reset-password') {
      final code = uri.queryParameters['code'];
      return code != null ? '/reset-password?code=$code' : null;
    }
    
    return null;
  }
}