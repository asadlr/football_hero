//lib\screens\onboarding.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logger/logger.dart';
import '../state/onboarding_state.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../localization/app_strings.dart';

class Onboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;

  const Onboarding({
    super.key,
    required this.userId,
    required this.onboardingState,
  });

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('-', '');
    
    if (text.length > 10) {
      return oldValue;
    }
    
    var formattedText = '';
    for (var i = 0; i < text.length; i++) {
      if (i == 3) {
        formattedText += '-';
      }
      if (i == 6) {
        formattedText += '-';
      }
      formattedText += text[i];
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

class _OnboardingState extends State<Onboarding> {
  late String userId;
  late OnboardingState _onboardingState;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedRole;
  DateTime? _selectedDate;
  bool _isLoading = false;
  
  String? _validatePhoneNumber(String? value) {
    if (_selectedRole == 'player') return null; // Players are exempt
    
    if (value == null || value.isEmpty) {
      return AppStrings.get('phone_label');
    }
    
    // Remove any hyphens for validation
    final cleanedPhone = value.replaceAll('-', '');
    
    // Israeli mobile phone number validation
    // Starts with 05, 03, 052, 053, etc. and total of 10 digits after removing hyphens
    final phoneRegex = RegExp(r'^0(5[0-9]|[23][0-9])[0-9]{7}$');
    
    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return AppStrings.get('phone_hint');
    }
    
    return null;
  }

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _selectedRole = widget.onboardingState.role;
    _initializeFields();
  }
  
  void _initializeFields() {
    // Pre-fill fields from state if available
    _nameController.text = _onboardingState.name ?? '';
    _addressController.text = _onboardingState.address ?? '';
    _cityController.text = _onboardingState.city ?? '';
    _selectedRole = _onboardingState.role;
    _selectedDate = _onboardingState.dateOfBirth;
    _phoneController.text = _onboardingState.phoneNumber ?? '';
    if (_selectedDate != null) {
      _dobController.text = "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
    }
  }
  
  Future<void> _deleteUserRoleData(String userId, String previousRole) async {
    try {
    AppLogger.info(message: 'Attempting to delete role data for user $userId with previous role $previousRole');

    // Existing code for deleting team memberships and community teams
    try {
      await Supabase.instance.client
          .from('team_members')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      AppLogger.error(message: 'Error deleting team_members: ${e.toString()}');
    }

    try {
      await Supabase.instance.client
          .from('community_teams')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      AppLogger.error(message: 'Error deleting community_teams: ${e.toString()}');
    }

      // Delete role-specific data
      switch (previousRole) {
        case 'player':
          await Supabase.instance.client
              .from('mentor_player')
              .delete()
              .eq('player_id', userId);
          await Supabase.instance.client
              .from('parent_player')
              .delete()
              .eq('player_id', userId);
          try {
            await Supabase.instance.client
                .from('players')
                .delete()
                .eq('id', userId);
          } catch (e) {
            AppLogger.info(message: 'Legacy players table may have been removed');
          }
          break;

        case 'coach':
          await Supabase.instance.client
              .from('users')
              .update({
                'certificate_number': null,
                'certificate_url': null,
                'is_professional': false,
                'personal_id': null
              })
              .eq('id', userId);
          try {
            await Supabase.instance.client
                .from('coaches')
                .delete()
                .eq('id', userId);
          } catch (e) {
            AppLogger.info(message: 'Legacy coaches table may have been removed');
          }
          break;

        case 'community_manager':
          try {
            await Supabase.instance.client
                .from('community_managers')
                .delete()
                .eq('user_id', userId);
          } catch (e) {
            AppLogger.info(message: 'Legacy community_managers table may have been removed');
          }
          break;

        case 'parent':
          await Supabase.instance.client
              .from('parent_player')
              .delete()
              .eq('parent_id', userId);
          try {
            await Supabase.instance.client
                .from('parents')
                .delete()
                .eq('parent_id', userId);
          } catch (e) {
            AppLogger.info(message: 'Legacy parents table may have been removed');
          }
          break;

        case 'mentor':
          await Supabase.instance.client
              .from('mentor_player')
              .delete()
              .eq('mentor_id', userId);
          await Supabase.instance.client
              .from('mentor_communities')
              .delete()
              .eq('mentor_id', userId);
          try {
            await Supabase.instance.client
                .from('mentors')
                .delete()
                .eq('id', userId);
          } catch (e) {
            AppLogger.info(message: 'Legacy mentors table may have been removed');
          }
          break;
      }

      // Clean up generic user data
      await Supabase.instance.client
          .from('event_attendees')
          .delete()
          .eq('user_id', userId);
      await Supabase.instance.client
          .from('forum_posts')
          .delete()
          .eq('user_id', userId);
      await Supabase.instance.client
          .from('replies')
          .delete()
          .eq('user_id', userId);
      await Supabase.instance.client
          .from('favorite_clubs')
          .delete()
          .eq('user_id', userId);

      AppLogger.info(message: 'Successfully deleted previous role data');
    } catch (e) {
    AppLogger.error(message: 'Comprehensive error in deleting role data: ${e.toString()}');
    rethrow;
  }
}

  Future<bool> _onWillPop() async {
    if (!mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(AppStrings.get('cancel_registration')),
        content: Text(AppStrings.get('cancel_registration_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(AppStrings.get('no')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext, true);
              await _deleteUserData();

              if (mounted) {
                context.go('/');
              }
            },
            child: Text(AppStrings.get('yes')),
          ),
        ],
      ),
    );

    if (!mounted) return false;
    return result ?? false;
  }
  
  Future<void> _deleteUserData() async {
    try {
      // Delete user data from all relevant tables
      await Supabase.instance.client
          .from('users')
          .delete()
          .eq('id', userId);
          
      // Handle auth deletion if needed
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      AppLogger.error(message: 'Error deleting user data');
    }
  }

  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final name = _nameController.text.trim();
        final dob = _selectedDate;
        final address = _addressController.text.trim();
        final city = _cityController.text.trim();
        final validRoles = ['guest', 'player', 'parent', 'coach', 'community_manager', 'mentor', 'admin', 'user'];
        final role = (_selectedRole != null && validRoles.contains(_selectedRole)) ? _selectedRole : 'player';

        AppLogger.info(message: 'Submitting role data');

        final phone = _phoneController.text.trim().replaceAll('-', '');
        final previousRole = _onboardingState.role;
        
        AppLogger.info(message: 'Submitting onboarding form');

        if (dob == null) {
          AppLogger.warning(message: 'DOB not selected');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.get('dob_validation'))),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final age = DateTime.now().year - dob.year;

        if (previousRole != null && role != previousRole) {
          AppLogger.info(message: 'Role change detected: from $previousRole to $role');
          
          try {
            await _deleteUserRoleData(userId, previousRole);
            AppLogger.info(message: 'Successfully deleted previous role data');
          } catch (e) {
            AppLogger.error(message: 'Detailed error in role data deletion: ${e.toString()}');
            
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.get('unexpected_error')),
                duration: const Duration(seconds: 5),
              ),
            );
            
            setState(() {
              _isLoading = false;
              _selectedRole = previousRole;
            });
            return;
          }
        }

        try {
          AppLogger.info(message: 'Updating user data in database');
          final response = await Supabase.instance.client.from('users').upsert({
            'id': userId,
            'name': name,
            'dob': dob.toIso8601String(),
            'age': age,
            'address': address,
            'city': city,
            'role': role,
            'phone_number': role == 'player' ? null : phone,
          });
          
          if (response != null && response.error != null) {
            AppLogger.error(message: 'Supabase Error occurred');
          } else {
            AppLogger.info(message: 'User data successfully updated');
          }

        } catch (e) {
          AppLogger.error(message: 'Error updating user data');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.get('unexpected_error')),
              duration: const Duration(seconds: 5),
            ),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final updatedState = _onboardingState.copyWith(
          name: name,
          dateOfBirth: dob,
          role: role,
          address: address,
          city: city,
          phoneNumber: role == 'player' ? null : phone,
        );

        if (!mounted) return;
        
        AppLogger.info(message: 'Navigating to next screen');
        _navigateBasedOnRole(role, updatedState);
        
      } catch (e) {
        AppLogger.error(message: 'Unexpected error in onboarding submission: ${e.toString()}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.get('unexpected_error')),
            duration: const Duration(seconds: 5),
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _navigateBasedOnRole(String? role, OnboardingState state) {
    if (role == null) {
      AppLogger.warning(message: 'No role selected');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get('user_type_validation'))),
      );
      return;
    }

    final args = {
      'userId': userId, 
      'onboardingState': state,
    };

    switch (role) {
      case 'player':
        context.go('/onboarding/player', extra: args);
      case 'parent':
        context.go('/onboarding/parent', extra: args);
      case 'coach':
        context.go('/onboarding/coach', extra: args);
      case 'mentor':
        context.go('/onboarding/mentor', extra: args);
      case 'community_manager':
        context.go('/onboarding/community', extra: args);
      default:
        AppLogger.warning(message: 'Unknown role selected');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('user_type_validation'))),
        );
    }
  }
  
  Future<void> _pickDate() async {
    AppLogger.info(message: 'Opening date picker');
    final pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('he'),
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _dobController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    } else {
      AppLogger.warning(message: 'Date picker canceled');
    }
  }

  @override
    Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
              color: AppColors.textPrimary,
              onPressed: () async {
                await _onWillPop();
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
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    elevation: AppTheme.theme.cardTheme.elevation ?? 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppStrings.get('onboarding_title'),
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontFamily: 'RubikDirt',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _nameController,
                              enabled: !_isLoading,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('name_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty 
                                  ? AppStrings.get('name_validation') 
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _dobController,
                              enabled: !_isLoading,
                              readOnly: true,
                              onTap: _pickDate,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('dob_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty 
                                  ? AppStrings.get('dob_validation') 
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: AppStrings.get('user_type_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              value: _selectedRole,
                              onChanged: _isLoading 
                                ? null 
                                : (value) => setState(() => _selectedRole = value),
                              items: [
                                DropdownMenuItem(
                                  value: 'player', 
                                  child: Text(AppStrings.get('user_roles.player')),
                                ),
                                DropdownMenuItem(
                                  value: 'parent', 
                                  child: Text(AppStrings.get('user_roles.parent')),
                                ),
                                DropdownMenuItem(
                                  value: 'coach', 
                                  child: Text(AppStrings.get('user_roles.coach')),
                                ),
                                DropdownMenuItem(
                                  value: 'community_manager', 
                                  child: Text(AppStrings.get('user_roles.community_manager')),
                                ),
                                DropdownMenuItem(
                                  value: 'mentor', 
                                  child: Text(AppStrings.get('user_roles.mentor')),
                                ),
                              ],
                              validator: (value) => 
                                value == null 
                                ? AppStrings.get('user_type_validation') 
                                : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _addressController,
                              enabled: !_isLoading,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('address_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty 
                                  ? AppStrings.get('address_validation') 
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _cityController,
                              enabled: !_isLoading,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('city_label'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty 
                                  ? AppStrings.get('city_validation') 
                                  : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _phoneController,
                              enabled: !_isLoading,
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.phone,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: AppStrings.get('phone_label'),
                                hintText: AppStrings.get('phone_hint'),
                                labelStyle: theme.textTheme.bodyMedium,
                                border: const OutlineInputBorder(),
                              ),
                              validator: _validatePhoneNumber,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                                _PhoneNumberFormatter(),
                              ],
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _submitAndNavigate,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    AppStrings.get('submit_button'),
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontFamily: 'VarelaRound',
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(77),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBlue,
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
 
  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}