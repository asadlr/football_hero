import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  Future<void> _sendPasswordResetEmail() async {
  final email = _emailController.text.trim();

  if (email.isEmpty) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('נא להזין דוא"ל')),
    );
    return;
  }

  try {
    await Supabase.instance.client.auth.resetPasswordForEmail(email);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('הודעת איפוס סיסמה נשלחה')),
    );

    if (mounted) Navigator.pop(context); // Navigate back only if mounted
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('שגיאה: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('איפוס סיסמה')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'הזן את הדוא"ל שלך ואנו נשלח קישור לאיפוס סיסמה',
              textAlign: TextAlign.center,
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
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: const Text('שלח קישור לאיפוס'),
            ),
          ],
        ),
      ),
    );
  }
}
