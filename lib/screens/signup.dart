//lib\screens\signup.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import '../logger/logger.dart';
import '../state/onboarding_state.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../localization/app_strings.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? userId;
  bool isTermsAccepted = false;
  bool _isLoading = false;
  
  // Password validation - added better security checks
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return AppStrings.get('password_too_short');
    }
    if (password.length < 8) {
      return AppStrings.get('password_too_short');
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return AppStrings.get('password_needs_uppercase');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return AppStrings.get('password_needs_number');
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppStrings.get('password_needs_special_char');
    }
    return null;
  }

  Future<bool> onWillPop() async {
    context.go('/');
    return false;
  }

  Future<void> signup() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      // Validation checks
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('invalid_email'))),
        );
        setState(() { _isLoading = false; });
        return;
      }

      // Enhanced password validation
      final passwordValidation = _validatePassword(password);
      if (passwordValidation != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(passwordValidation)),
        );
        setState(() { _isLoading = false; });
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('passwords_not_matching'))),
        );
        setState(() { _isLoading = false; });
        return;
      }

      if (!isTermsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('terms_acceptance'))),
        );
        setState(() { _isLoading = false; });
        return;
      }

      AppLogger.info(message: 'Starting signup process');

      final supabase = Supabase.instance.client;

      // Signup process
      try {
        final authResponse = await supabase.auth.signUp(
          email: email,
          password: password,
          data: {
            'timestamp': DateTime.now().toIso8601String(),
            'registration_source': 'app_signup',
          },
        );

        // Extract user
        final user = authResponse.user;

        if (user == null) {
          AppLogger.error(message: 'Signup failed: No user returned');
          throw 'Signup failed: No user returned';
        }

        userId = user.id;
        AppLogger.info(message: 'User created successfully');

        // Create onboarding state
        final onboardingState = OnboardingState(email: email);

        // Navigate to onboarding using GoRouter
        if (mounted) {
          context.go('/onboarding', extra: {
            'userId': userId,
            'onboardingState': onboardingState,
          });
          AppLogger.info(message: 'Navigation completed');
        }

      } on AuthException catch (e) {
        // Handle specific signup errors
        if (e.message.toLowerCase().contains('user already registered')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.get('user_already_registered'))),
            );
          }
          setState(() { _isLoading = false; });
          return;
        }
        
        // Handle other auth exceptions with generic message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.get('signup_create_error'))),
          );
        }
      }
    } catch (e) {
      AppLogger.error(message: 'Unexpected error during signup');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('signup_unexpected_error'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await onWillPop();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: AppColors.textPrimary,
              onPressed: () {
                onWillPop();
              },
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/mainBackground.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    elevation: AppTheme.theme.cardTheme.elevation ?? 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.get('signup_screen_title'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontFamily: 'RubikDirt',
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: emailController,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              labelText: AppStrings.get('email_hint'),
                              labelStyle: theme.textTheme.bodyMedium,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              labelText: AppStrings.get('password_hint'),
                              labelStyle: theme.textTheme.bodyMedium,
                              border: const OutlineInputBorder(),
                              helperText: AppStrings.get('password_requirements'),
                              helperStyle: theme.textTheme.bodySmall,
                              helperMaxLines: 2,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              labelText: AppStrings.get('confirm_password_hint'),
                              labelStyle: theme.textTheme.bodyMedium,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Checkbox(
                                value: isTermsAccepted,
                                activeColor: AppColors.primaryBlue,
                                onChanged: (value) {
                                  setState(() {
                                    isTermsAccepted = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  AppStrings.get('terms_acceptance'),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _isLoading ? null : signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: _isLoading
                              ? const SizedBox(
                                  height: 20, 
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white)
                                )
                              : Text(
                                AppStrings.get('signup_button_text'),
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontFamily: 'VarelaRound',
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(77),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}