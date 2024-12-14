import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:football_hero/screens/success_screen.dart';
import 'package:football_hero/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('נא למלא את כל השדות')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(userId: response.user!.id),
          ),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה בכניסה: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה בלתי צפויה: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Enforces RTL layout
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center, // Aligns text to the right
                          children: [
                            const Text(
                              'כניסה למערכת',
                              textAlign: TextAlign.center, // Text aligned to the right
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'RubikDirt',
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _emailController,
                              textAlign: TextAlign.right, // Aligns input text to the right
                              decoration: const InputDecoration(
                                labelText: 'דוא"ל',
                                alignLabelWithHint: true, // Ensures label aligns correctly for RTL
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: _passwordController,
                              textAlign: TextAlign.right, // Aligns input text to the right
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'סיסמה',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: _login,
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
                                'כניסה',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPasswordScreen(),
                                ),
                              ),
                              child: const Text(
                                'שכחת סיסמה?',
                                textAlign: TextAlign.center, // Text aligned to the center  
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'VarelaRound',
                                  fontSize: 16,
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
}
