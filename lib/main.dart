import 'package:flutter/material.dart';
import 'package:football_hero/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Hero',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'VarelaRound',// Main font
        ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signup': (context) => const PlaceholderScreen(title: 'Signup'),
        '/login': (context) => const PlaceholderScreen(title: 'Login'),
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Screen Placeholder')),
    );
  }
}
