// lib/widgets/common/component_library.dart
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../localization/localization_manager.dart';

class ComponentLibrary {
  // Private constructor to prevent instantiation
  ComponentLibrary._();

  /// Standardized card component
  static Widget buildCard({
    required BuildContext context,
    required String title,
    required Widget content,
    Color? backgroundColor,
    double? height,
    VoidCallback? onTap,
    Widget? trailing,
    bool showDivider = true,
  }) {
    final theme = Theme.of(context);
    final localizationManager = LocalizationManager();
    
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
      ),
      color: backgroundColor ?? Colors.white.withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 0.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: localizationManager.isRTL
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              // Header with title and optional trailing widget
              Row(
                textDirection: localizationManager.textDirection,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  if (trailing != null) trailing,
                ],
              ),
              
              // Divider, if enabled
              if (showDivider)
                Divider(
                  color: Colors.grey.withOpacity(0.3),
                  height: 16.0,
                ),
              
              // Main content
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }

  /// Standardized action button
  static Widget buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
    bool isOutlined = false,
  }) {
    final theme = Theme.of(context);
    final buttonColor = color ?? theme.primaryColor;
    
    return isOutlined
        ? OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18.0),
            label: Text(label),
            style: OutlinedButton.styleFrom(
              foregroundColor: buttonColor,
              side: BorderSide(color: buttonColor),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, size: 18.0),
            label: Text(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
            ),
          );
  }

  /// Standardized list item for consistent list views
  static Widget buildListItem({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: leading,
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: trailing,
          onTap: onTap,
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: leading != null ? 56.0 : 0.0,
          ),
      ],
    );
  }

  /// Standardized avatar for users, teams, or communities
  static Widget buildAvatar({
    required String name,
    String? imageUrl,
    double size = 40.0,
    Color? backgroundColor,
  }) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
      child: imageUrl == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            )
          : null,
    );
  }

  /// Standardized section header
  static Widget buildSectionHeader({
    required BuildContext context,
    required String title,
    VoidCallback? onActionPressed,
    String? actionLabel,
  }) {
    final theme = Theme.of(context);
    final localizationManager = LocalizationManager();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        textDirection: localizationManager.textDirection,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          if (actionLabel != null && onActionPressed != null)
            TextButton(
              onPressed: onActionPressed,
              child: Text(
                actionLabel,
                style: TextStyle(
                  fontSize: 12.0,
                  color: theme.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Standardized chip for status, tags, etc.
  static Widget buildChip({
    required String label,
    Color? backgroundColor,
    Color? textColor,
    bool isOutlined = false,
    IconData? icon,
  }) {
    final bgColor = backgroundColor ?? Colors.blue.withOpacity(0.1);
    final fgColor = textColor ?? Colors.blue;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : bgColor,
        border: isOutlined ? Border.all(color: fgColor) : null,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.0, color: fgColor),
            const SizedBox(width: 4.0),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: fgColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Standardized progress indicator
  static Widget buildProgressIndicator({
    required double value,
    Color? color,
    double height = 6.0,
    String? label,
  }) {
    final progressColor = color ?? Colors.blue;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4.0),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: height,
          ),
        ),
      ],
    );
  }
}