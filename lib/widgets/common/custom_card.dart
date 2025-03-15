// lib/widgets/common/custom_card.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';
import '../../localization/localization_manager.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final Color? backgroundColor;
  final double? height;
  final VoidCallback? onTap;
  final AppRole? role;
  final double? borderRadius;

  const CustomCard({
    super.key,
    this.title,
    required this.child,
    this.backgroundColor,
    this.height,
    this.onTap,
    this.role,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizationManager = LocalizationManager();
    
    // Determine background color based on role or default
    final cardColor = backgroundColor ?? 
      (role != null 
        ? AppColors.withOpacity(AppColors.getRoleColor(role!), 0.1)
        : theme.cardTheme.color);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        elevation: theme.cardTheme.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? ThemeConstants.borderRadius
          ),
        ),
        margin: ThemeConstants.cardMargin,
        child: Container(
          height: height,
          padding: ThemeConstants.cardPadding,
          child: Column(
            crossAxisAlignment: localizationManager.isRTL 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    title!,
                    style: theme.textTheme.titleMedium,
                    textAlign: localizationManager.isRTL 
                        ? TextAlign.right 
                        : TextAlign.left,
                  ),
                ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}