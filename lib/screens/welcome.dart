//lib\screens\welcome.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../localization/app_strings.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  void _navigateToSignup(BuildContext context) {
    context.go('/signup');
  }

  void _navigateToLogin(BuildContext context) {
    context.go('/login');
  }

  Future<void> _launchURL(BuildContext context) async {
    final url = Uri.parse('https://hoodhero.app/footballhero/he');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('network_error'))),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('general_error'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/images/welcomeBackground.webp',
                fit: BoxFit.cover,
              ),
            ),
            // Content Section
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Headline Text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'ברוכים הבאים!', // This can be added to app_strings.dart later
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontFamily: 'RubikDirt',
                      ),
                    ),
                  ),

                  // Sign Up Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      gradient: AppColors.playerGradient,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryBlue.withAlpha(186),
                          blurRadius: 10.0,
                          offset: const Offset(3, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => _navigateToSignup(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 70.0,
                          vertical: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Text(
                        'הצטרפו לקבוצה!', // This could be added to app_strings.dart
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 28,
                          color: Colors.white,
                          fontFamily: 'RubikDirt',
                        ),
                      ),
                    ),
                  ),

                  // Log In Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(230),
                          blurRadius: 10.0,
                          offset: const Offset(3, 4),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: () => _navigateToLogin(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 70.0,
                          vertical: 15.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      child: Text(
                        'כניסת משתמשים', // This could be added to app_strings.dart
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 28,
                          color: Colors.black,
                          fontFamily: 'RubikDirt',
                        ),
                      ),
                    ),
                  ),

                  // Info Link
                  GestureDetector(
                    onTap: () => _launchURL(context),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        'לחצו כאן למידע נוסף על FootballHero\nותכנית HoodHero', // This could be added to app_strings.dart
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontFamily: 'VarelaRound',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30.0), // Bottom Spacing
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}