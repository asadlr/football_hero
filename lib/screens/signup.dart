import 'package:flutter/material.dart';
import 'package:football_hero/screens/onboarding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _acceptTerms = false;

  Future<void> _validateAndSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_acceptTerms) {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        try {
          final response = await Supabase.instance.client.auth.signUp(
            email: email,
            password: password,
          );

          final userId = response.user?.id;

          if (mounted && userId != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Onboarding(userId: userId),
              ),
            );
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('שגיאה: $e')),
            );
          }
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
            // Background Image
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
                  color: Colors.white.withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
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
                          TextFormField(
                            controller: _emailController,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'דוא"ל',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'נא להזין דוא"ל'
                                    : null,
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'סיסמה',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.length < 6
                                    ? 'סיסמה לא תקינה'
                                    : null,
                          ),
                          const SizedBox(height: 20.0),
                          CheckboxListTile(
                            value: _acceptTerms,
                            onChanged: (value) =>
                                setState(() => _acceptTerms = value!),
                            title: const Text(
                              'אני מסכים/ה לתנאי השימוש',
                              style: TextStyle(
                                fontFamily: 'VarelaRound',
                              ),
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          const SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: _validateAndSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
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
                                fontFamily: 'RubikDirt',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
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
