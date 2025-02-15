import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logger/logger.dart';
import '../state/onboarding_state.dart';
import 'package:flutter/services.dart';

class Onboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;

  const Onboarding({
    super.key,
    required this.userId,
    required this.onboardingState,
  });

  @override
  State<Onboarding> createState() => _OnboardingState(); // Change this line
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
  bool _isLoading = false; // Add this line
  
  String? _validatePhoneNumber(String? value) {
    if (_selectedRole == 'player') return null; // Players are exempt
    
    if (value == null || value.isEmpty) {
      return 'נא להזין מספר טלפון';
    }
    
    // Remove any hyphens for validation
    final cleanedPhone = value.replaceAll('-', '');
    
    // Israeli mobile phone number validation
    // Starts with 05, 03, 052, 053, etc. and total of 10 digits after removing hyphens
    final phoneRegex = RegExp(r'^0(5[0-9]|[23][0-9])[0-9]{7}$');
    
    if (!phoneRegex.hasMatch(cleanedPhone)) {
      return 'אנא הזן מספר טלפון תקין (10 ספרות)';
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
    debugPrint('Onboarding initialized with userId: $userId'); // Removed unnecessary braces
  }
  
  void _initializeFields() {
    // Pre-fill fields from state if available
    _nameController.text = _onboardingState.name ?? '';
    _addressController.text = _onboardingState.address ?? '';
    _cityController.text = _onboardingState.city ?? '';
    _selectedRole = _onboardingState.role;
    _selectedDate = _onboardingState.dateOfBirth;
    _phoneController.text = _onboardingState.phoneNumber ?? ''; // Add this line
    if (_selectedDate != null) {
      _dobController.text = "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
    }
  }
  
Future<void> _deleteUserRoleData(String userId, String previousRole) async {
  try {
    // First delete role-specific team memberships
    await Supabase.instance.client
      .from('team_members')
      .delete()
      .eq('user_id', userId);

    // Then delete role-specific data
    switch (previousRole) {
      case 'player':
        // Delete player data
        await Supabase.instance.client
          .from('players')
          .delete()
          .eq('id', userId);
        break;
      
      case 'coach':
        AppLogger.info('Starting to delete coach data for user: $userId');
        
        // Delete coach data
        await Supabase.instance.client
          .from('coaches')
          .delete()
          .eq('id', userId);
        
        // Delete certificate files from storage
        try {
          final fileList = await Supabase.instance.client
            .storage
            .from('coach_certificate')
            .list(path: userId);

          for (final file in fileList) {
            final fullPath = '$userId/${file.name}';
            await Supabase.instance.client
              .storage
              .from('coach_certificate')
              .remove([fullPath]);
          }

          // Check for files directly named with user ID
          final allFiles = await Supabase.instance.client
            .storage
            .from('coach_certificate')
            .list();

          final userFiles = allFiles.where((file) => 
            file.name.startsWith('${userId}_')
          ).toList();

          for (final file in userFiles) {
            await Supabase.instance.client
              .storage
              .from('coach_certificate')
              .remove([file.name]);
          }
        } catch (storageError, storageStackTrace) {
          AppLogger.error(
            'Error deleting coach certificate files', 
            error: storageError,
            stackTrace: storageStackTrace
          );
        }
        break;

      case 'community':
        // Delete community manager data
        await Supabase.instance.client
          .from('community_managers')
          .delete()
          .eq('user_id', userId);
        break;

      case 'parent':
        // Delete parent-player relationships
        await Supabase.instance.client
          .from('parents')
          .delete()
          .eq('parent_id', userId);
        break;

      case 'mentor':
        // Delete mentor data
        await Supabase.instance.client
          .from('mentor_communities')
          .delete()
          .eq('mentor_id', userId);
        await Supabase.instance.client
          .from('mentors')
          .delete()
          .eq('id', userId);
        break;
      }

    // Clean up any event attendances
    await Supabase.instance.client
      .from('event_attendees')
      .delete()
      .eq('user_id', userId);

    // Clean up any forum posts
    await Supabase.instance.client
      .from('forum_posts')
      .delete()
      .eq('user_id', userId);

    // Clean up any announcement replies
    await Supabase.instance.client
      .from('replies')
      .delete()
      .eq('user_id', userId);

    // Clean up any favorite clubs
    await Supabase.instance.client
      .from('favorite_clubs')
      .delete()
      .eq('user_id', userId);

    AppLogger.info('Successfully deleted previous role data for user: $userId, previous role: $previousRole');
  } catch (e, stackTrace) {
    AppLogger.error(
      'Error deleting previous role data', 
      error: e, 
      stackTrace: stackTrace
    );
    rethrow;
  }
}


Future<bool> _onWillPop() async {
  if (!mounted) return false; // Check if the State is still mounted

  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) => AlertDialog(
      title: const Text('לבטל הרשמה?'),
      content: const Text('האם את/ה בטוח/ה שברצונך לבטל את ההרשמה? כל הנתונים שהוזנו ימחקו'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('לא'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext, true); // Close dialog first
            await _deleteUserData(); // Do async operation

            if (mounted) { // Check if the widget is still mounted
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          child: const Text('כן'),
        ),
      ],
    ),
  );

  if (!mounted) return false; // Final check before returning result
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
      debugPrint('Error deleting user data: $e');
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
      final role = _selectedRole;
      final phone = _phoneController.text.trim().replaceAll('-', '');
      final previousRole = _onboardingState.role;

      AppLogger.info('Submitting onboarding form');
      AppLogger.info('User Info: Name: $name, DOB: $dob, Role: $role, Previous Role: $previousRole');

      if (dob == null) {
        AppLogger.warning('DOB not selected');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אנא בחר תאריך לידה')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final age = DateTime.now().year - dob.year;

      // Handle role change and data deletion if necessary
      if (previousRole != null && role != previousRole) {
        AppLogger.info('Role change detected: $previousRole -> $role');
        
        // Show confirmation dialog for role change
        if (!mounted) return;
        final shouldProceed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('שינוי תפקיד'),
            content: const Text('שינוי התפקיד ימחק את כל הנתונים הקשורים לתפקיד הקודם. האם להמשיך?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('ביטול'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('המשך'),
              ),
            ],
          ),
        ) ?? false;

        if (!shouldProceed) {
          setState(() {
            _isLoading = false;
            _selectedRole = previousRole; // Revert role selection
          });
          return;
        }

        try {
          AppLogger.info('Starting to delete previous role data');
          await _deleteUserRoleData(userId, previousRole);
        } catch (e, stackTrace) {
          AppLogger.error('Failed to delete previous role data', error: e, stackTrace: stackTrace);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('שגיאה במחיקת נתוני תפקיד קודם. אנא נסה שוב מאוחר יותר'),
              duration: Duration(seconds: 5),
            ),
          );
          setState(() {
            _isLoading = false;
            _selectedRole = previousRole; // Revert role selection
          });
          return;
        }
      }

      // Update user data
      try {
        AppLogger.info('Updating user data in database');
        await Supabase.instance.client.from('users').upsert({
          'id': userId,
          'name': name,
          'dob': dob.toIso8601String(),
          'age': age,
          'address': address,
          'city': city,
          'role': role,
          'phone_number': role == 'player' ? null : phone, // Only save for non-players
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (e, stackTrace) {
        AppLogger.error('Error updating user data', error: e, stackTrace: stackTrace);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('שגיאה בעדכון פרטי משתמש. אנא נסה שוב'),
            duration: Duration(seconds: 5),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Update onboarding state
      final updatedState = _onboardingState.copyWith(
        name: name,
        dateOfBirth: dob,
        role: role,
        address: address,
        city: city,
        phoneNumber: role == 'player' ? null : phone,

      );

      if (!mounted) return;
      
      AppLogger.info('Navigating based on role: $role');
      _navigateBasedOnRole(role, updatedState);
      
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error in onboarding submission', error: e, stackTrace: stackTrace);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('שגיאה לא צפויה: $e'),
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
      AppLogger.warning('No role selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('סוג משתמש לא נבחר')),
      );
      return;
    }

    final args = {
      'userId': userId, 
      'role': role,
      'onboardingState': state,
    };
  
    switch (role) {
      case 'player':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/player',
          arguments: args,
        );
      case 'parent':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/parent',
          arguments: args,
        );
      case 'coach':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/coach',
          arguments: args,
        );
      case 'mentor':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/mentor',
          arguments: args,
        );
      case 'community':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/community',
          arguments: args,
        );
      default:
        AppLogger.warning('Unknown role selected');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('סוג משתמש לא ידוע')),
        );
    }
  }

  Future<void> _pickDate() async {
    AppLogger.info('Opening date picker');
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
      AppLogger.info('Date selected: $pickedDate');
    } else {
      AppLogger.warning('Date picker canceled');
    }
  }

 @override
Widget build(BuildContext context) {
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
            color: Colors.black,
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
                  color: Colors.white.withAlpha(230),
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
                          const Text(
                            'השלמת הרשמה',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'RubikDirt',
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _nameController,
                            enabled: !_isLoading,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'שמך',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'נא להזין שם' : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _dobController,
                            enabled: !_isLoading,
                            readOnly: true,
                            onTap: _pickDate,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'תאריך לידה',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'נא לבחור תאריך לידה' : null,
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'סוג משתמש',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedRole,
                            onChanged: _isLoading ? null : (value) => setState(() => _selectedRole = value),
                            items: const [
                              DropdownMenuItem(value: 'player', child: Text('שחקן')),
                              DropdownMenuItem(value: 'parent', child: Text('הורה')),
                              DropdownMenuItem(value: 'coach', child: Text('מאמן')),
                              DropdownMenuItem(value: 'community', child: Text('צוות קהילתי')),
                              DropdownMenuItem(value: 'mentor', child: Text('מנטור')),
                            ],
                            validator: (value) => value == null ? 'נא לבחור סוג משתמש' : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _addressController,
                            enabled: !_isLoading,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'כתובת',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'נא להזין כתובת' : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _cityController,
                            enabled: !_isLoading,
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'עיר',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'נא להזין עיר' : null,
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _phoneController,
                            enabled: !_isLoading,
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'מספר טלפון',
                              hintText: 'הזן מספר טלפון (לדוגמה: 050-1234567)',
                              border: OutlineInputBorder(),
                            ),
                            validator: _validatePhoneNumber,
                            inputFormatters: [
                              // Allow only numbers and hyphens
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                              // Auto-format phone number with hyphens
                              _PhoneNumberFormatter(),
                            ],
                          ),
                          const SizedBox(height: 20),                          
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _submitAndNavigate,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'שלח',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    fontStyle: FontStyle.italic,
                                    fontFamily: 'VarelaRound',
                                    color: Colors.white,
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
                color: Colors.black.withAlpha(77), // 0.3 opacity = 77 in alpha (0.3 * 255 ≈ 77)
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
 
 
   @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose(); // Add this new line
    super.dispose();
  }
}