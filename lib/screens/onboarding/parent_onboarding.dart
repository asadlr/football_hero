// lib/screens/onboarding/parent_onboarding.dart
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/onboarding_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../localization/app_strings.dart';
import '../../localization/localization_manager.dart';

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
      AppLogger.error(message: 'Error fetching player email');
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
      AppLogger.info(message: 'Verifying player email');
      
      final response = await Supabase.instance.client
          .rpc('get_player_by_email', params: {'search_email': email});
      
      if (response != null && response is List && response.isNotEmpty) {
        final userData = response[0] as Map<String, dynamic>;

        final userId = userData['user_id'] as String?;
        final existsAsPlayer = userData['exists_as_player'] as bool?;
        final playerName = userData['player_name'] as String?;
        final dateOfBirth = userData['date_of_birth'] as String?;

        if (userId == null || existsAsPlayer != true) {
          AppLogger.info(message: 'User not found or not a player');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.get('player_not_found')),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return null;
        }

        AppLogger.info(message: 'Valid player found');
        return {
          'userId': userId,
          'playerName': playerName,
          'dateOfBirth': dateOfBirth,
        };
      } else {
        AppLogger.info(message: 'No user found or empty response');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.get('player_not_found')),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return null;
      }
    } catch (e) {
      AppLogger.error(message: 'Error verifying player');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('player_search_error'))),
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
          title: Text(AppStrings.get('verify_player_details')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.get('name_label')}: ${playerData['playerName'] ?? AppStrings.get('not_available')}'
              ),
              Text(
                '${AppStrings.get('dob_label')}: ${playerData['dateOfBirth'] ?? AppStrings.get('not_available')}'
              ),
              const SizedBox(height: ThemeConstants.md),
              Text(AppStrings.get('confirm_player_details')),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppStrings.get('no')),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(AppStrings.get('yes')),
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
            SnackBar(content: Text(AppStrings.get('player_verification_cancelled'))),
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
      AppLogger.error(message: 'Error in parent onboarding submission');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('unexpected_error'))),
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
    final theme = Theme.of(context);
    final localizationManager = LocalizationManager();
    
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Directionality(
        textDirection: localizationManager.textDirection,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: AppColors.textPrimary,
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
                child: Card(
                  margin: const EdgeInsets.all(18.0),
                  elevation: AppTheme.theme.cardTheme.elevation,
                  shape: AppTheme.theme.cardTheme.shape,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            AppStrings.get('parent_registration_title'),
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: ThemeConstants.md),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildParentIdField(theme),
                                const SizedBox(height: ThemeConstants.md),
                                _buildPlayerEmailField(theme),
                                const SizedBox(height: ThemeConstants.md),
                                ElevatedButton(
                                  onPressed: _isLoading ? null : _submitAndNavigate,
                                  style: theme.elevatedButtonTheme.style,
                                  child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
                                        AppStrings.get('continue_button'),
                                        style: theme.textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                        ),
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
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(77),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.parentColor,
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

  Widget _buildParentIdField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('personal_id_label'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: ThemeConstants.sm),
        TextFormField(
          controller: _parentIdController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.get('personal_id_required');
            }
            if (value.length != 9) {
              return AppStrings.get('personal_id_length');
            }
            return null;
          },
          keyboardType: TextInputType.number,
          maxLength: 9,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPlayerEmailField(ThemeData theme) {
    if (!_isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.parentColor,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('player_email_optional'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: ThemeConstants.sm),
        TextFormField(
          controller: _playerEmailController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
            hintText: AppStrings.get('leave_empty_if_no_player'),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty && !value.contains('@')) {
              return AppStrings.get('invalid_email');
            }
            return null;
          },
          style: theme.textTheme.bodyMedium,
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