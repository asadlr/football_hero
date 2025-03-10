// lib\widgets\common\fan_zone_preview.dart

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class FanZonePreview extends StatelessWidget {
  final VoidCallback? onViewAll;

  const FanZonePreview({
    super.key,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
      ),
      child: Padding(
        padding: AppTheme.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fan Zone News',
                  style: textTheme.headlineSmall,
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('View All'),
                  ),
              ],
            ),
            SizedBox(height: AppTheme.spacing + 2),
            
            // News Item 1
            _buildNewsItem(
              'New community event announced!',
              'Join us for a friendly match this weekend...',
              'assets/images/placeholder.jpg',
              '2h ago',
              context,
            ),
            const Divider(),
            
            // News Item 2
            _buildNewsItem(
              'Training tips from pro coaches',
              'Improve your skills with these techniques...',
              'assets/images/placeholder.jpg',
              '1d ago',
              context,
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build news items
  Widget _buildNewsItem(
    String title, 
    String preview, 
    String imagePath, 
    String timeAgo,
    BuildContext context,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.spacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for the image - replace with actual image when available
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.photo, color: Colors.white),
          ),
          SizedBox(width: AppTheme.spacing + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppTheme.spacing / 2),
                Text(
                  preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
                SizedBox(height: AppTheme.spacing / 2),
                Text(
                  timeAgo,
                  style: textTheme.labelSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}