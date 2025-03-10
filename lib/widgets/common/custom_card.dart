// lib\widgets\common\custom_card.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double height;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double borderRadius;

  const CustomCard({
    super.key,
    required this.title,
    required this.child,
    this.height = 180,
    this.padding = const EdgeInsets.all(16.0),
    this.backgroundColor,
    this.gradient,
    this.borderRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    // Use AppTheme for standard card styling
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      height: height,
      decoration: BoxDecoration(
        color: gradient == null 
            ? AppTheme.applyCardOpacity(backgroundColor ?? Colors.white)
            : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
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
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
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