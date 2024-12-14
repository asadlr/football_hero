import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToSignup(BuildContext context) {
    Navigator.pushNamed(context, '/signup');
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  Future<void> _launchURL() async {
    final url = Uri.parse('https://hoodhero.app/footballhero/he');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Force RTL layout
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
            // Buttons and Footer Info
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(), // Push content downward

                  // signUp Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade300, Colors.blue.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade900.withOpacity(0.5),
                          blurRadius: 10.0,
                          offset: Offset(3, 4),
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
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: const Text(
                          'הצטרפו לקבוצה!', // Hebrew for "Join The Team!"
                          key: ValueKey('JoinButtonText'),
                          style: TextStyle(
                            fontSize: 28, // Enlarged by 10%
                            fontWeight: FontWeight.w300, // Lighter font weight
                            fontStyle: FontStyle.italic, // Italic style
                            color: Colors.white,
                            fontFamily: 'RubikDirt',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30.0),

                  // logIn Button
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 10.0,
                          offset: Offset(3, 4),
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
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.transparent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: const Text(
                          'כניסת משתמשים', // Hebrew for "Log In"
                          key: ValueKey('LoginButtonText'),
                          style: TextStyle(
                            fontSize: 28, // Same size as signUp button
                            fontWeight: FontWeight.w300, // Lighter font weight
                            fontStyle: FontStyle.italic, // Italic style
                            color: Colors.black,
                            fontFamily: 'RubikDirt',
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30.0), // Adjusted spacing

                  // HoodHero Info Link
                  GestureDetector(
                    onTap: _launchURL,
                    child: const Text(
                      'לחצו כאן למידע נוסף על FootballHero\nותכנית HoodHero', // Hebrew translation
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, // Same size as buttons
                        fontWeight: FontWeight.w300, // Lighter font weight
                        fontStyle: FontStyle.italic, // Italic style
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontFamily: 'VarelaRound',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
