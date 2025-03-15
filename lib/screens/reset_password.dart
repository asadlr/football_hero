//lib\screens\reset_password.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../localization/app_strings.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String accessToken;

  const ResetPasswordScreen({super.key, required this.accessToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  
  bool isLoading = false;
  String? errorMessage;
  bool isSessionRecovered = false;

  @override
  void initState() {
    super.initState();
    _verifyResetToken();
  }

  Future<void> _verifyResetToken() async {
    try {
      String tokenStr = widget.accessToken.toString();
      
      if (tokenStr.isNotEmpty) {
        setState(() {
          isSessionRecovered = true;
        });
      } else {
        throw Exception('Empty token');
      }
    } catch (error) {
      setState(() {
        errorMessage = AppStrings.get('token_verification_error');
        isSessionRecovered = false;
      });
    }
  }

  Future<void> _updatePassword() async {
    // Validate session recovery first
    if (!isSessionRecovered) {
      setState(() {
        errorMessage = AppStrings.get('token_verification_error');
      });
      return;
    }

    // Clear previous error message
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    // Validate email
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        errorMessage = AppStrings.get('invalid_email');
        isLoading = false;
      });
      return;
    }

    // Validate password
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty) {
      setState(() {
        errorMessage = AppStrings.get('password_needs_special_char');
        isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        errorMessage = AppStrings.get('passwords_not_matching');
        isLoading = false;
      });
      return;
    }

    if (password.length < 8) {
      setState(() {
        errorMessage = AppStrings.get('password_too_short');
        isLoading = false;
      });
      return;
    }

    try {
      // Verify and set new session
      final res = await supabase.auth.verifyOTP(
        email: email,
        token: widget.accessToken,
        type: OtpType.recovery,
      );

      if (res.session == null) {
        throw Exception(AppStrings.get('token_invalid'));
      }
      
      // Update password
      final updateRes = await supabase.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );
      
      if (updateRes.user == null) {
        throw Exception('Failed to update password');
      }
      
      setState(() {
        isLoading = false;
      });

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.get('password_reset_success')),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      
      // Navigate to login page after successful reset
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/login');
        }
      });
      
    } on AuthException catch (authError) {
      setState(() {
        errorMessage = _getLocalizedErrorMessage(authError);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = AppStrings.get('unexpected_error');
        isLoading = false;
      });
    }
  }
  
  String _getLocalizedErrorMessage(AuthException error) {
    switch (error.message) {
      case 'Invalid session':
        return AppStrings.get('token_verification_error');
      case 'User not found':
        return AppStrings.get('user_not_found');
      case 'Password is too short':
        return AppStrings.get('password_too_short');
      case 'invalid flow state, no valid flow state found':
        return AppStrings.get('token_invalid');
      default:
        return AppStrings.get('unexpected_error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/mainBackground.webp',
                fit: BoxFit.cover,
              ),
            ),
            // Logo
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.webp',
                fit: BoxFit.none,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 150.0),
                    Card(
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
                              AppStrings.get('reset_password_title'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontFamily: 'RubikDirt',
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(
                              AppStrings.get('reset_password_subtitle'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: emailController,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.emailAddress,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('email_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: passwordController,
                              textAlign: TextAlign.right,
                              obscureText: true,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('new_password'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: confirmPasswordController,
                              textAlign: TextAlign.right,
                              obscureText: true,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('confirm_password'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                            if (errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  errorMessage!,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primaryRed,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: isLoading || !isSessionRecovered ? null : _updatePassword,
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
                              child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppStrings.get('reset_password_button'),
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontFamily: 'RubikDirt',
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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