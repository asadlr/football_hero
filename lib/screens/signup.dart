import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logger/logger.dart';
import '../state/onboarding_state.dart';
import 'package:go_router/go_router.dart';

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
      return 'נא להזין סיסמה';
    }
    if (password.length < 8) {
      return 'הסיסמה חייבת להיות באורך של 8 תווים לפחות';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'הסיסמה חייבת להכיל לפחות אות גדולה אחת';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'הסיסמה חייבת להכיל לפחות ספרה אחת';
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'הסיסמה חייבת להכיל לפחות תו מיוחד אחד';
    }
    return null;
  }

  Future<bool> onWillPop() async {
    context.go('/');
    return false;
  }

  Future<void> signup() async {
    setState(() {
      _isLoading = true; // Set loading state
    });
    
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      final confirmPassword = confirmPasswordController.text.trim();

      // Validation checks
      if (email.isEmpty || !email.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אנא הזן כתובת דוא"ל תקינה')),
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
          const SnackBar(content: Text('הסיסמאות אינן תואמות')),
        );
        setState(() { _isLoading = false; });
        return;
      }

      if (!isTermsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אנא אשר את תנאי השימוש')),
        );
        setState(() { _isLoading = false; });
        return;
      }

      AppLogger.info('Starting signup process');

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
          AppLogger.error('Signup failed: No user returned');
          throw 'Signup failed: No user returned';
        }

        userId = user.id;
        AppLogger.info('User created successfully');

        // Create onboarding state
        final onboardingState = OnboardingState(email: email);

        // Navigate to onboarding using GoRouter
        if (mounted) {
          context.go('/onboarding', extra: {
            'userId': userId,
            'onboardingState': onboardingState,
          });
          AppLogger.info('Navigation completed');
        }

      } on AuthException catch (e) {
        // Handle specific signup errors
        if (e.message.toLowerCase().contains('user already registered')) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('משתמש זה כבר רשום במערכת')),
            );
          }
          setState(() { _isLoading = false; });
          return;
        }
        
        // Handle other auth exceptions with generic message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('שגיאה ביצירת המשתמש. אנא נסה שוב.')),
          );
        }
      }
    } catch (e) {
      AppLogger.error('Unexpected error during signup');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה בלתי צפויה. אנא נסה שוב מאוחר יותר.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Reset loading state
        });
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
                              helperText: '8 תווים לפחות, אות גדולה, ספרה ותו מיוחד',
                              helperMaxLines: 2,
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
                            onPressed: _isLoading ? null : signup,
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
                            child: _isLoading
                              ? const SizedBox(
                                  height: 20, 
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white)
                                )
                              : const Text(
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
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(77),
                    child: const Center(
                      child: CircularProgressIndicator(),
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