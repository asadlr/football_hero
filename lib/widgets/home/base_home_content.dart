// lib/widgets/home/base_home_content.dart
import 'package:flutter/material.dart';
import '../../localization/localization_manager.dart';
import '../../theme/app_theme.dart';

abstract class BaseHomeContent extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Map<String, Color>? cardColors;

  const BaseHomeContent({
    Key? key,
    required this.userData,
    this.cardColors,
  }) : super(key: key);
  
  // Abstract methods that must be implemented by subclasses
  List<Widget> buildContentSections(BuildContext context);
  
  @override
  Widget build(BuildContext context) {
    // Get current text direction from localization manager
    final textDirection = LocalizationManager().textDirection;
    
    return Directionality(
      textDirection: textDirection,
      child: ListView(
        padding: const EdgeInsets.only(top: 16.0, bottom: 80.0),
        children: buildContentSections(context),
      ),
    );
  }
  
  // Helper method to get effective card colors
  Map<String, Color> getEffectiveCardColors(String role) {
    return cardColors ?? AppTheme.getCardColorsForRole(role);
  }
}