// lib/screens/settings_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../localization/localization_manager.dart';
import '../localization/app_strings.dart';
import '../config/dependency_injection.dart';
import '../widgets/debug/performance_dashboard.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // App version - would come from your app's build config in a real app
  final String _appVersion = '1.0.0';
  
  // Notification settings
  bool _enablePushNotifications = true;
  bool _enableEmailNotifications = true;
  
  @override
  void initState() {
    super.initState();
    
    // Track screen view
    if (dependencyInjection.analyticsService != null) {
      dependencyInjection.analyticsService.trackScreenView('settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizationManager = Provider.of<LocalizationManager>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('settings')),
      ),
      body: ListView(
        children: [
          // Language settings
          _buildSectionHeader(AppStrings.get('language_settings')),
          ListTile(
            title: Text(AppStrings.get('app_language')),
            subtitle: Text(_getLanguageName(localizationManager.currentLocale.languageCode)),
            trailing: DropdownButton<String>(
              value: localizationManager.currentLocale.languageCode,
              underline: Container(),
              items: [
                DropdownMenuItem(
                  value: 'he',
                  child: Text('עברית'),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  localizationManager.setLocale(Locale(value, ''));
                  
                  // Track language change
                  if (dependencyInjection.analyticsService != null) {
                    dependencyInjection.analyticsService.trackUserAction('language_changed', {
                      'language': value,
                    });
                  }
                }
              },
            ),
          ),
          
          const Divider(),
          
          // Appearance settings
          _buildSectionHeader(AppStrings.get('appearance_settings')),
          ListTile(
            title: Text(AppStrings.get('theme')),
            subtitle: Text(_getThemeModeName(themeProvider.themeMode)),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              underline: Container(),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(AppStrings.get('system_theme')),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(AppStrings.get('light_theme')),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(AppStrings.get('dark_theme')),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  // Apply theme change through the provider
                  themeProvider.setThemeMode(value);
                  
                  // Track theme change
                  if (dependencyInjection.analyticsService != null) {
                    dependencyInjection.analyticsService.trackUserAction('theme_changed', {
                      'theme': value.toString(),
                    });
                  }
                }
              },
            ),
          ),
          
          const Divider(),
          
          // Notification settings
          _buildSectionHeader(AppStrings.get('notification_settings')),
          SwitchListTile(
            title: Text(AppStrings.get('push_notifications')),
            subtitle: Text(AppStrings.get('push_notifications_desc')),
            value: _enablePushNotifications,
            onChanged: (value) {
              setState(() {
                _enablePushNotifications = value;
              });
              
              // Save notification preference
              if (dependencyInjection.analyticsService != null) {
                dependencyInjection.analyticsService.trackUserAction('notification_toggled', {
                  'type': 'push',
                  'enabled': value,
                });
              }
            },
          ),
          SwitchListTile(
            title: Text(AppStrings.get('email_notifications')),
            subtitle: Text(AppStrings.get('email_notifications_desc')),
            value: _enableEmailNotifications,
            onChanged: (value) {
              setState(() {
                _enableEmailNotifications = value;
              });
              
              // Save notification preference
              if (dependencyInjection.analyticsService != null) {
                dependencyInjection.analyticsService.trackUserAction('notification_toggled', {
                  'type': 'email',
                  'enabled': value,
                });
              }
            },
          ),
          
          const Divider(),
          
          // About section
          _buildSectionHeader(AppStrings.get('about')),
          ListTile(
            title: Text(AppStrings.get('app_version')),
            subtitle: Text(_appVersion),
            trailing: const Icon(Icons.info_outline),
            // Secret gesture to access performance dashboard in debug mode
            onLongPress: () {
              // Only show in debug mode
              if (kDebugMode) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PerformanceDashboard(),
                  ),
                );
              }
            },
          ),
          ListTile(
            title: Text(AppStrings.get('terms_of_service')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to terms of service
              if (dependencyInjection.analyticsService != null) {
                dependencyInjection.analyticsService.trackUserAction('viewed_terms');
              }
            },
          ),
          ListTile(
            title: Text(AppStrings.get('privacy_policy')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to privacy policy
              if (dependencyInjection.analyticsService != null) {
                dependencyInjection.analyticsService.trackUserAction('viewed_privacy');
              }
            },
          ),
          ListTile(
            title: Text(AppStrings.get('contact_us')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Navigate to contact form
              if (dependencyInjection.analyticsService != null) {
                dependencyInjection.analyticsService.trackUserAction('contact_us_clicked');
              }
            },
          ),
          
          // Account actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: ElevatedButton(
              onPressed: () {
                // Implement account logout
                if (dependencyInjection.analyticsService != null) {
                  dependencyInjection.analyticsService.trackUserAction('logout');
                }
                // Actually log out the user...
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(AppStrings.get('logout')),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
  
  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'he':
        return 'עברית';
      default:
        return languageCode;
    }
  }
  
  String _getThemeModeName(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return AppStrings.get('system_theme');
      case ThemeMode.light:
        return AppStrings.get('light_theme');
      case ThemeMode.dark:
        return AppStrings.get('dark_theme');
    }
  }
}