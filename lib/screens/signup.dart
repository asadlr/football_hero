import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logger/logger.dart';
import '../state/onboarding_state.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? userId;
  bool isTermsAccepted = false;

  Future<bool> onWillPop() async {
    Navigator.pushReplacementNamed(context, '/');
    return false;
  }

Future<void> signup() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      // Validation checks
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אנא הזן כתובת דוא"ל תקינה')),
        );
        return;
      }

      if (password.isEmpty || password.length < 6) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('הסיסמה חייבת להיות באורך של 6 תווים לפחות')),
        );
        return;
      }

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('הסיסמאות אינן תואמות')),
        );
        return;
      }

      if (!isTermsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אנא אשר את תנאי השימוש')),
        );
        return;
      }

      AppLogger.info('=== Starting signup process ===');
      AppLogger.info('Email entered: $email');

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
        // Remove unused session variable

        if (user == null) {
          AppLogger.error('Signup failed: No user returned');
          throw 'Signup failed: No user returned';
        }

        userId = user.id;
        AppLogger.info('User created in auth system. ID: $userId');

        // Create onboarding state
        final onboardingState = OnboardingState(email: email);

        // Navigate to onboarding
        if (mounted) {
          await Navigator.pushReplacementNamed(
            context,
            '/onboarding',
            arguments: {
              'userId': userId,
              'onboardingState': onboardingState,
            },
          );
          AppLogger.info('Navigation completed successfully');
        }

      } on AuthException catch (e) {
        // Handle specific signup errors
        if (e.message.toLowerCase().contains('user already registered')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('משתמש זה כבר רשום במערכת')),
            );
          }
          return;
        }
        // Re-throw other auth exceptions
        rethrow;
      }
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during signup', 
        error: {
          'Error': e.toString(),
          'StackTrace': stackTrace.toString()
        });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בלתי צפויה: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black,
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
                    color: const Color.fromRGBO(255, 255, 255, 0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'הרשמה',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'RubikDirt',
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'דוא"ל',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'סיסמה',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'אימות סיסמה',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              Checkbox(
                                value: isTermsAccepted,
                                onChanged: (value) {
                                  setState(() {
                                    isTermsAccepted = value!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'אני מסכים/ה לתנאי השימוש',
                                  style: TextStyle(
                                    fontFamily: 'VarelaRound',
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: signup,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'יצירת חשבון',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
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
            ],
          ),
        ),
      ),
    );
  }
}