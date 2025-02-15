import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/mainBackground.webp', // Use the same image path as in FavoritesScreen
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Text(
              "ברוכים הבאים!",
              style: TextStyle(
                fontSize: 50, // Adjust font size as needed
                fontWeight: FontWeight.bold, // Adjust font weight as needed
                color: Colors.white, // Adjust color as needed - make sure it contrasts well with background
              ),
            ),
          ),
        ],
      ),
    );
  }
}