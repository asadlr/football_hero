// lib/screens/parent_onboarding.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/onboarding_state.dart';

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
  bool _isPlayerValid = false;
  bool _isInitialized = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _parentIdController = TextEditingController();
  final TextEditingController _playerEmailController = TextEditingController();
  String? _playerUserId;

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
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
      final response = await Supabase.instance.client
          .from('users')
          .select('email')
          .eq('id', _playerUserId!)
          .single();
      
      if (response.isNotEmpty) {
        setState(() {
          _playerEmailController.text = response['email'] as String;
          _isPlayerValid = true;
        });
      }
    } catch (e) {
      AppLogger.error('Error fetching player email');
    }
  }

  void _handleBack() {
    // Update the onboardingState with all current form data
    final updatedState = _onboardingState.copyWith(
      parentId: _parentIdController.text.trim(),
      playerUserId: _playerUserId,
    );

    context.go('/onboarding', extra: {
      'userId': _userId,
      'onboardingState': updatedState,
    });
  }

  Future<Map<String, dynamic>?> _verifyPlayer(String email) async {
    try {
      AppLogger.info('Verifying player email');
      
      final response = await Supabase.instance.client
          .rpc('get_player_by_email', params: {'search_email': email});
      
      if (response != null && response is List && response.isNotEmpty) {
        final userData = response[0] as Map<String, dynamic>;

        final userId = userData['user_id'] as String?;
        final existsAsPlayer = userData['exists_as_player'] as bool?;
        final playerName = userData['player_name'] as String?;
        final dateOfBirth = userData['date_of_birth'] as String?;

        if (userId == null || existsAsPlayer != true) {
          AppLogger.info('User not found or not a player');
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

        AppLogger.info('Valid player found');
        return {
          'userId': userId,
          'playerName': playerName,
          'dateOfBirth': dateOfBirth,
        };
      } else {
        AppLogger.info('No user found or empty response');
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
    } catch (e) {
      AppLogger.error('Error verifying player');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אירעה שגיאה בחיפוש השחקן')),
        );
      }
      return null;
    }
  }

  Future<bool> _showVerificationPopup(Map<String, dynamic> playerData) async {
    if (!mounted) return false;

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('אימות פרטי השחקן'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('שם: ${playerData['playerName'] ?? 'לא זמין'}'),
              Text('תאריך לידה: ${playerData['dateOfBirth'] ?? 'לא זמין'}'),
              const SizedBox(height: 20),
              const Text('האם אלו הפרטים הנכונים של השחקן?'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('לא'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('כן'),
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
      final personalId = _parentIdController.text.trim();
      
      // Update personal_id in the users table
      await Supabase.instance.client
          .from('users')
          .update({'personal_id': personalId})
          .eq('id', _userId);
      
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
        
        // Create parent-player relationship in the new table
        if (_playerUserId != null) {
          await Supabase.instance.client
              .from('parent_player')
              .upsert({
                'parent_id': _userId,
                'player_id': _playerUserId,
                'status': 'pending',
                'created_by': _userId,
                'created_at': DateTime.now().toIso8601String()
              },
              onConflict: 'parent_id,player_id');
        }
      } else {
        // No player email provided, proceed without player verification
        setState(() {
          _isPlayerValid = false;
          _playerUserId = null;
        });
      }

      if (mounted) {
        context.go('/onboarding/favorites', extra: {
          'userId': _userId,
          'onboardingState': _onboardingState.copyWith(
            parentId: personalId,
            playerUserId: _playerUserId,
          ),
        });
      }
    } catch (e) {
      AppLogger.error('Error in parent onboarding submission');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אירעה שגיאה בעיבוד הבקשה. אנא נסה שוב.')),
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
              onPressed: _handleBack,
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
                    color: Colors.white.withAlpha(230),
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'המשך',
                                      style: TextStyle(fontSize: 15, color: Colors.white),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(77),
                    child: const Center(
                      child: CircularProgressIndicator(),
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