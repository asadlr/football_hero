import 'package:flutter/material.dart';
import 'package:football_hero/screens/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _acceptTerms = false;

  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_acceptTerms) {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        try {
          // Supabase signup call
          final response = await Supabase.instance.client.auth.signUp(
            email: email,
            password: password,
          );

          if (response.user != null) {
            // Navigate to the onboarding screen after successful registration
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OnboardingScreen(userId: response.user!.id),
              ),
            );
          }
        } on AuthException catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('שגיאה בהרשמה: ${e.message}')),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('שגיאה בלתי צפויה התרחשה: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('נא להסכים לתנאי השימוש')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/mainBackground.webp',
                fit: BoxFit.cover,
              ),
            ),
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
                      color: Colors.white.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'יצירת חשבון חדש',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'RubikDirt',
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'דוא"ל',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'נא להזין דוא"ל';
                                  }
                                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                    return 'דוא"ל לא תקין';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'סיסמה',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'נא להזין סיסמה';
                                  }
                                  if (value.length < 6) {
                                    return 'סיסמה חייבת להכיל לפחות 6 תווים';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'אימות סיסמה',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return 'הסיסמאות לא תואמות';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _acceptTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        _acceptTerms = value!;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => launchUrl(
                                        Uri.parse('https://hoodhero.app/footballhero/he/terms'),
                                        mode: LaunchMode.externalApplication,
                                      ),
                                      child: const Text(
                                        'אני מסכים/ה לתנאי השימוש של האפליקציה',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontFamily: 'VarelaRound',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _validateAndSubmit,
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
                                      color: Colors.white,
                                      fontFamily: 'RubikDirt',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}
