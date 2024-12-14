import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String userId;

  const SuccessScreen({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('הרשמה הצליחה')), // "Signup Success" in Hebrew
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ברוך הבא!', // "Welcome!" in Hebrew
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'User ID: $userId',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: Text('חזור למסך הראשי'), // "Back to Home Screen" in Hebrew
            ),
          ],
        ),
      ),
    );
  }
}
