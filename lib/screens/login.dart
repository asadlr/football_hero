// lib\screens\login.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../localization/app_strings.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('empty_fields_error'))),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (!mounted) return;
          context.go('/home', extra: {'userId': response.user!.id});
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_getLocalizedErrorMessage(e.message))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('login_error'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getLocalizedErrorMessage(String errorMessage) {
    if (errorMessage.contains('Invalid login credentials')) {
      return AppStrings.get('invalid_credentials');
    } else if (errorMessage.contains('Email not confirmed')) {
      return AppStrings.get('email_not_confirmed');
    } else if (errorMessage.contains('Too many requests')) {
      return AppStrings.get('too_many_requests');
    }
    return AppStrings.get('login_error');
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
                              AppStrings.get('login_screen_title'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontFamily: 'RubikDirt',
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _emailController,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('email_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _passwordController,
                              textAlign: TextAlign.right,
                              obscureText: true,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('password_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _login,
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
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                  AppStrings.get('login_button_text'),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontFamily: 'RubikDirt',
                                  ),
                                ),
                            ),
                            const SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () => context.push('/forgot-password'),
                              child: Text(
                                AppStrings.get('forgot_password'),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: AppColors.primaryBlue,
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
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
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
    );
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}