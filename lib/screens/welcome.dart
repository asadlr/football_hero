import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

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
        // Show a user-friendly error without exposing the URL
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('לא ניתן לפתוח את הקישור. נסה שוב מאוחר יותר.')),
        );
      }
    } catch (e) {
      // Handle exceptions gracefully without exposing details
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('אירעה שגיאה בפתיחת הקישור. נסה שוב מאוחר יותר.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // RTL layout for Hebrew
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
                  const Spacer(), // Push content downward

                  // Headline Text
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      'ברוכים הבאים!', // "Welcome!" in Hebrew
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'RubikDirt',
                      ),
                    ),
                  ),

                  // Sign Up Button
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade300, Colors.blue.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withAlpha(186), // Fixed deprecated color usage
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
                      child: const Text(
                        'הצטרפו לקבוצה!', // Hebrew for "Join The Team!"
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
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
                          color: Colors.black.withAlpha(230), // Fixed deprecated color usage
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
                      child: const Text(
                        'כניסת משתמשים', // Hebrew for "Log In"
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                          fontFamily: 'RubikDirt',
                        ),
                      ),
                    ),
                  ),

                  // Info Link
                  GestureDetector(
                    onTap: () => _launchURL(context), // Added context
                    child: const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        'לחצו כאן למידע נוסף על FootballHero\nותכנית HoodHero', // Hebrew
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
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