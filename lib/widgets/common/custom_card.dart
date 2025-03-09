// lib\widgets\common\custom_card.dart

import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double borderRadius;

  const CustomCard({
    Key? key,
    required this.title,
    required this.child,
    this.height = 180,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.gradient,
    this.borderRadius = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      height: height,
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor ?? Colors.white : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl, // RTL support
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 16.0, left: 16.0), // RTL padding
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2c3e50),
              ),
              textDirection: TextDirection.rtl, // RTL support
            ),
          ),
          Expanded(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}