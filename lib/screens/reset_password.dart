import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String accessToken;

  const ResetPasswordScreen({super.key, required this.accessToken});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  
  bool isLoading = false;
  String? errorMessage;
  bool isSuccess = false;
  bool isSessionRecovered = false;

  @override
  void initState() {
    super.initState();
    // Removed sensitive token logging
    
    // Attempt to verify the OTP token
    _verifyResetToken();
  }

  Future<void> _verifyResetToken() async {
    try {
      // For type safety, make sure the token is treated as a string
      String tokenStr = widget.accessToken.toString();
      
      // The token is used directly in the password reset process
      // For testing purposes, we'll just validate it's present
      if (tokenStr.isNotEmpty) {
        setState(() {
          isSessionRecovered = true;
        });
      } else {
        throw Exception('Empty token');
      }
    } catch (error) {
      // Removed sensitive error logging
      setState(() {
        errorMessage = 'שגיאה באימות הקישור. אנא נסה לאפס סיסמה שוב.';
        isSessionRecovered = false;
      });
    }
  }


  Future<void> updatePassword() async {
    // Validate session recovery first
    if (!isSessionRecovered) {
      setState(() {
        errorMessage = 'לא ניתן לאפס סיסמה. אנא נסה שוב.';
      });
      return;
    }

    // Clear previous error message
    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    // Validate email
    final email = emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        errorMessage = "נא להזין כתובת דוא\"ל תקינה";
        isLoading = false;
      });
      return;
    }

    // Validate password match and strength
    if (passwordController.text.isEmpty) {
      setState(() {
        errorMessage = "נא להזין סיסמה חדשה";
        isLoading = false;
      });
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      setState(() {
        errorMessage = "הסיסמאות אינן תואמות";
        isLoading = false;
      });
      return;
    }

    if (passwordController.text.length < 6) {
      setState(() {
        errorMessage = "הסיסמה צריכה להיות באורך של 6 תווים לפחות";
        isLoading = false;
      });
      return;
    }

    try {
      // Step 1: Try to use the token to verify and set a new session
      // This is required before we can update the user password
      final res = await supabase.auth.verifyOTP(
        email: email, // Add the email here
        token: widget.accessToken,
        type: OtpType.recovery,
      );

      if (res.session == null) {
        throw Exception('Failed to verify token');
      }
      
      // Step 2: Now we have a valid session, update the password
      final updateRes = await supabase.auth.updateUser(
        UserAttributes(
          password: passwordController.text.trim(),
        ),
      );
      
      if (updateRes.user == null) {
        throw Exception('Failed to update password');
      }
      
      setState(() {
        isLoading = false;
        isSuccess = true;
      });

      // Show success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("הסיסמה עודכנה בהצלחה!"),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to login page after successful reset
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          context.go('/login');
        }
      });
      
    } on AuthException catch (authError) {
      setState(() {
        errorMessage = _getLocalizedErrorMessage(authError);
        isLoading = false;
      });
      // Removed sensitive auth error logging
    } catch (error) {
      setState(() {
        errorMessage = "שגיאה בעת איפוס הסיסמה. אנא נסה שוב."; // Generic error message
        isLoading = false;
      });
      // Removed sensitive error logging
    }
  }
  
  
  String _getLocalizedErrorMessage(AuthException error) {
    switch (error.message) {
      case 'Invalid session':
        return 'פג תוקף ההתחברות. אנא נסה לאפס סיסמה שוב.';
      case 'User not found':
        return 'המשתמש לא נמצא. אנא בדוק את הפרטים.';
      case 'Password is too short':
        return 'הסיסמה צריכה להיות באורך של 6 תווים לפחות.';
      case 'invalid flow state, no valid flow state found':
        return 'קישור האיפוס פג תוקף. אנא בקש קישור איפוס סיסמה חדש.';
      default:
        return 'שגיאה בעדכון הסיסמה. אנא נסה שוב.'; // Generic error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/mainBackground.webp',
                fit: BoxFit.cover,
              ),
            ),
            // Logo
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/logo.webp',
                fit: BoxFit.none,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 150.0),
                    Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      color: const Color.fromRGBO(255, 255, 255, 0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'איפוס סיסמה',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'RubikDirt',
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            const Text(
                              "הזן סיסמה חדשה לחשבונך",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20.0),
                            // Add email field here
                            TextField(
                              controller: emailController,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'דוא"ל',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: passwordController,
                              textAlign: TextAlign.right,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'סיסמה חדשה',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                            const SizedBox(height: 20.0),
                            TextField(
                              controller: confirmPasswordController,
                              textAlign: TextAlign.right,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'אישור סיסמה',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(),
                              ),
                              textDirection: TextDirection.ltr,
                            ),
                            if (errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: isLoading || !isSessionRecovered ? null : updatePassword,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50.0,
                                  vertical: 15.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'אפס סיסמה',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.white,
                                      fontFamily: 'RubikDirt',
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}