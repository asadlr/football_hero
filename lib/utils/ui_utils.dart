// lib/utils/ui_utils.dart
import 'package:flutter/material.dart';
import '../localization/localization_manager.dart';

class UIUtils {
  // Private constructor to prevent instantiation
  UIUtils._();
  
  /// Get alignment based on text direction
  static Alignment getStartAlignment(BuildContext context, LocalizationManager manager) {
    return manager.isRTL ? Alignment.centerRight : Alignment.centerLeft;
  }
  
  /// Get end alignment based on text direction
  static Alignment getEndAlignment(BuildContext context, LocalizationManager manager) {
    return manager.isRTL ? Alignment.centerLeft : Alignment.centerRight;
  }
  
  /// Get padding with RTL awareness
  static EdgeInsets getDirectionalPadding({
    required double start,
    required double end,
    required double top,
    required double bottom,
    required LocalizationManager manager,
  }) {
    return manager.isRTL
        ? EdgeInsets.fromLTRB(end, top, start, bottom)
        : EdgeInsets.fromLTRB(start, top, end, bottom);
  }
  
  /// Build a responsive grid layout with RTL support
  static Widget buildResponsiveGrid({
    required BuildContext context,
    required List<Widget> children,
    required int columns,
    required double spacing,
    required LocalizationManager manager,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = (width - (spacing * (columns - 1))) / columns;
        
        return Wrap(
          direction: Axis.horizontal,
          textDirection: manager.textDirection,
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((child) {
            return SizedBox(
              width: itemWidth,
              child: child,
            );
          }).toList(),
        );
      },
    );
  }
  
  /// Memory-efficient image loading
  static Widget loadImage({
    required String? imageUrl,
    required double width,
    required double height,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return placeholder ?? Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: Icon(Icons.image, color: Colors.grey[400]),
      );
    }
    
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / 
                  loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Icon(Icons.broken_image, color: Colors.grey[400]),
        );
      },
    );
  }
  
  /// Build a performant list with lazy loading
  static Widget buildLazyList<T>({
    required List<T> items,
    required Widget Function(BuildContext, T, int) itemBuilder,
    required String emptyMessage,
    bool shrinkWrap = true,
    ScrollPhysics? physics,
    double? maxHeight,
    EdgeInsets? padding,
  }) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(emptyMessage),
        ),
      );
    }
    
    final listView = ListView.builder(
      itemCount: items.length,
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
    
    if (maxHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: listView,
      );
    }
    
    return listView;
  }
}