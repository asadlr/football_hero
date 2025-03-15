  // lib/widgets/common/language_selector.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../localization/localization_manager.dart';
import '../../localization/app_strings.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationManager>(
      builder: (context, localizationManager, _) {
        // Current locale info
        final isRTL = localizationManager.isRTL;
        final currentLanguage = localizationManager.currentLocale.languageCode;
        
        return PopupMenuButton<String>(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.language,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                _getLanguageCode(currentLanguage),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          tooltip: AppStrings.get('change_language'),
          offset: Offset(0, 40),
          onSelected: (String languageCode) {
            localizationManager.setLocale(Locale(languageCode, ''));
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'he',
              child: Row(
                children: [
                  Text('עברית'),
                  Spacer(),
                  if (currentLanguage == 'he')
                    Icon(Icons.check, color: Colors.green, size: 16),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'en',
              child: Row(
                children: [
                  Text('English'),
                  Spacer(),
                  if (currentLanguage == 'en')
                    Icon(Icons.check, color: Colors.green, size: 16),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  
  // Helper to show the right language code
  String _getLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'he':
        return 'עב';
      case 'en':
        return 'EN';
      default:
        return languageCode.toUpperCase();
    }
  }
}