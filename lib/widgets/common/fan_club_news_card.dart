// lib\widgets\common\fan_club_news_card.dart

import 'package:flutter/material.dart';
import 'news_item.dart';
import 'custom_card.dart';
import '../../localization/app_strings.dart';
import '../../theme/app_theme.dart';

class FanClubNewsCard extends StatelessWidget {
  final List<Map<String, dynamic>> news;
  final String clubName;
  final Color? backgroundColor;

  const FanClubNewsCard({
    super.key,
    required this.news,
    required this.clubName,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    
    return CustomCard(
      title: '${AppStrings.fanClub} - $clubName',
      height: 220,
      backgroundColor: backgroundColor,
      child: news.isEmpty
          ? Center(
              child: Text(
                AppStrings.noNews,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                textDirection: TextDirection.rtl,
              ),
            )
          : ListView.builder(
              itemCount: news.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final item = news[index];
                return NewsItem(
                  title: item['title'],
                  source: item['source'],
                  time: item['time'],
                  onTap: () {
                    // Handle news item tap
                  },
                );
              },
            ),
    );
  }
}