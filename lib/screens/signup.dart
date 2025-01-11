import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logger/logger.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? userId;
  bool _isTermsAccepted = false;

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    AppLogger.info('Signup process started');
    AppLogger.info('Email: $email');

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      AppLogger.warning('Empty fields detected');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('נא למלא את כל השדות')),
      );
      return;
    }

    if (password != confirmPassword) {
      AppLogger.warning('Password mismatch detected');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('הסיסמאות אינן תואמות')),
      );
      return;
    }

    if (!_isTermsAccepted) {
      AppLogger.warning('Terms and conditions not accepted');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('אנא אשרו את תנאי השימוש')),
      );
      return;
    }

    try {
      AppLogger.info('Attempting signup with Supabase');
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );


      // Validate user creation
      if (response.user == null || response.user!.id.isEmpty) {
        AppLogger.error('Signup failed: User ID is invalid or missing');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('שגיאה בהרשמה: יצירת משתמש נכשלה')),
        );
        return;
      }
      userId = response.user!.id;
      // Log and navigate
      AppLogger.info('Signup successful: User ID: ${response.user!.id}');
      
      if (!mounted) return;

      await Navigator.pushReplacementNamed(
        context,
        '/onboarding',
        arguments: {'userId': userId},
      );
    } on AuthException catch (e) {
      AppLogger.error('AuthException during signup', error: e.message);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה בהרשמה: ${e.message}')),
      );
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during signup', error: e, stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה בלתי צפויה: $e')),
      );
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
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  color: const Color.fromRGBO(255, 255, 255, 0.9), // Adjusted for precision
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
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'דוא"ל',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'סיסמה',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextField(
                          controller: _confirmPasswordController,
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
                              value: _isTermsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _isTermsAccepted = value!;
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
                          onPressed: _signup,
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
    );
  }
}
