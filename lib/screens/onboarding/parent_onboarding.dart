// lib/screens/parent_onboarding.dart

import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/onboarding_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ParentOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;

  const ParentOnboarding({
    super.key, 
    required this.userId, 
    required this.onboardingState,
  });

  @override
  State<ParentOnboarding> createState() => _ParentOnboardingState();
}

class _ParentOnboardingState extends State<ParentOnboarding> {
  late String _userId;
  late OnboardingState _onboardingState;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _parentIdController = TextEditingController();
  final TextEditingController _playerEmailController = TextEditingController();
  String? _playerUserId;
  bool _isPlayerValid = false;
  bool _isInitialized = false;

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
    debugPrint('ParentOnboarding initialized with userId: $_userId');
  }

  void _initializeFields() {
    // Pre-fill fields from the onboardingState
    _parentIdController.text = _onboardingState.parentId ?? '';
    _playerUserId = _onboardingState.playerUserId;

    if (_playerUserId != null) {
      // Fetch and set player email if we have playerUserId
      _fetchPlayerEmail();
    }

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _fetchPlayerEmail() async {
    if (_playerUserId == null) return;
    
    try {
      // Need to use the auth.users table through admin api, not directly
      final response = await Supabase.instance.client
          .from('users') // Changed from 'auth.users' to 'users'
          .select('email')
          .eq('id', _playerUserId!)
          .single();
      
      if (response != null) {
        setState(() {
          _playerEmailController.text = response['email'] as String;
          _isPlayerValid = true;
        });
      }
    } catch (e) {
      debugPrint('Error fetching player email: $e');
    }
  }

  void _handleBack() {
    // Update the onboardingState with all current form data
    final updatedState = _onboardingState.copyWith(
      parentId: _parentIdController.text.trim(),
      playerUserId: _playerUserId,
    );

    Navigator.pushReplacementNamed(
      context,
      '/onboarding',
      arguments: {
        'userId': _userId,
        'onboardingState': updatedState,
      },
    );
  }

 Future<Map<String, dynamic>?> _verifyPlayer(String email) async {
  print('Function called with email: $email');
  try {
    print('================== START VERIFY PLAYER ==================');
    print('Searching for email: $email');
    
    final response = await Supabase.instance.client
        .rpc('get_player_by_email', params: {'search_email': email});
    
    print('Raw Response: $response');

    if (response != null && response is List && response.isNotEmpty) {
      final userData = response[0] as Map<String, dynamic>;
      print('User data: $userData');

      final userId = userData['user_id'] as String?;
      final existsAsPlayer = userData['exists_as_player'] as bool?;
      final playerName = userData['player_name'] as String?;
      final dateOfBirth = userData['date_of_birth'] as String?;

      print('User ID: $userId');
      print('Exists as Player: $existsAsPlayer');
      print('Player Name: $playerName');
      print('Date of Birth: $dateOfBirth');

      if (userId == null || existsAsPlayer != true) {
        print('User not found or not a player');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('שחקן לא נמצא'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      }

      print('Valid player found!');
      return {
        'userId': userId,
        'playerName': playerName,
        'dateOfBirth': dateOfBirth,
      };
    } else {
      print('No user found or empty response');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('שחקן לא נמצא'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  } catch (e, stackTrace) {
    print('================== ERROR ==================');
    print('Error type: ${e.runtimeType}');
    print('Error message: $e');
    print('Stack trace: $stackTrace');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('אירעה שגיאה בחיפוש השחקן: $e')),
      );
    }
    return null;
  } finally {
    print('================== END VERIFY PLAYER ==================');
  }
}
Future<bool> _showVerificationPopup(Map<String, dynamic> playerData) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('אימות פרטי השחקן'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('שם: ${playerData['playerName'] ?? 'לא זמין'}'),
            Text('תאריך לידה: ${playerData['dateOfBirth'] ?? 'לא זמין'}'),
            SizedBox(height: 20),
            Text('האם אלו הפרטים הנכונים של השחקן?'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('לא'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('כן'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ) ?? false;
}


Future<void> _submitAndNavigate() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final playerEmail = _playerEmailController.text.trim();
    
    if (playerEmail.isNotEmpty) {
      // Verify player only if email is provided
      final playerData = await _verifyPlayer(playerEmail);
      if (playerData == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Show verification popup
      final verified = await _showVerificationPopup(playerData);
      if (!verified) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אימות השחקן בוטל')),
        );
        return;
      }

      // Set the verified player data
      setState(() {
        _isPlayerValid = true;
        _playerUserId = playerData['userId'];
      });
    } else {
      // No player email provided, proceed without player verification
      setState(() {
        _isPlayerValid = false;
        _playerUserId = null;
      });
    }

    // Insert into parents table
    await Supabase.instance.client
        .from('parents')
        .upsert({
          'parent_id': _userId,
          'player_id': _playerUserId,
        },
        onConflict: 'parent_id');

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        '/onboarding/favorites',
        arguments: {
          'userId': _userId,
          'onboardingState': _onboardingState.copyWith(
            parentId: _parentIdController.text.trim(),
            playerUserId: _playerUserId,
          ),
        },
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('אירעה שגיאה: $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
Future<bool> _checkUserExists(String userId) async {
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select('id')
          .eq('id', userId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: Colors.black,
              onPressed: () {
                _handleBack();
              },
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/mainBackground.webp',
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.all(18.0),
                  padding: const EdgeInsets.all(18.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'הורה - שלב ההרשמה',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildParentIdField(),
                              const SizedBox(height: 20),
                              _buildPlayerEmailField(),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitAndNavigate,
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('המשך'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParentIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'מספר תעודת זהות:',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _parentIdController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: alternateThemeColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'נא להזין מספר תעודת זהות';
            }
            if (value.length != 9) {
              return 'מספר תעודת זהות חייב להכיל 9 ספרות';
            }
            return null;
          },
          keyboardType: TextInputType.number,
          maxLength: 9,
        ),
      ],
    );
  }

Widget _buildPlayerEmailField() {
  if (!_isInitialized) {
    return const Center(child: CircularProgressIndicator());
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'אימייל השחקן (אופציונלי):',
        style: TextStyle(fontSize: 15),
      ),
      const SizedBox(height: 10),
      TextFormField(
        controller: _playerEmailController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: alternateThemeColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          isDense: true,
          hintText: 'השאר ריק אם אין שחקן משויך',
        ),
        validator: (value) {
          if (value != null && value.isNotEmpty && !value.contains('@')) {
            return 'נא להזין אימייל תקין';
          }
          return null;
        },
      ),
    ],
  );
}
  @override
  void dispose() {
    _parentIdController.dispose();
    _playerEmailController.dispose();
    super.dispose();
  }
}