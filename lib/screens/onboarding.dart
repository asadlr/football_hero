import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logger/logger.dart';
import '../state/onboarding_state.dart';

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

class _OnboardingState extends State<Onboarding> {
  late String userId;
  late OnboardingState _onboardingState;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? _selectedRole;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
    debugPrint('Onboarding initialized with userId: $userId');
  }

  void _initializeFields() {
    // Pre-fill fields from state if available
    _nameController.text = _onboardingState.name ?? '';
    _addressController.text = _onboardingState.address ?? '';
    _cityController.text = _onboardingState.city ?? '';
    _selectedRole = _onboardingState.role;
    _selectedDate = _onboardingState.dateOfBirth;
    if (_selectedDate != null) {
      _dobController.text = "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
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
      final name = _nameController.text.trim();
      final dob = _selectedDate;
      final address = _addressController.text.trim();
      final city = _cityController.text.trim();
      final role = _selectedRole;

      AppLogger.info('Submitting onboarding form');
      AppLogger.info('User Info: Name: $name, DOB: $dob, Role: $role');

      if (dob == null) {
        AppLogger.warning('DOB not selected');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אנא בחר תאריך לידה')),
        );
        return;
      }

      final age = DateTime.now().year - dob.year;

      try {
        AppLogger.info('Saving user data to Supabase');
        await Supabase.instance.client.from('users').upsert({
          'id': userId,
          'name': name,
          'dob': dob.toIso8601String(),
          'age': age,
          'address': address,
          'city': city,
          'role': role,
          'created_at': DateTime.now().toIso8601String(),
        });

        // Update onboarding state
        final updatedState = _onboardingState.copyWith(
          name: name,
          dateOfBirth: dob,
          role: role,
          address: address,
          city: city,
        );

        if (!mounted) return;
        AppLogger.info('Navigating based on role: $role');
        _navigateBasedOnRole(role, updatedState);
      } catch (e, stackTrace) {
        AppLogger.error('Error saving user data', error: e, stackTrace: stackTrace);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה: $e')),
        );
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
      canPop: false,  // Prevent default pop behavior
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
              // ... Rest of your existing build method remains the same
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
                              onChanged: (value) => setState(() => _selectedRole = value),
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
                              textAlign: TextAlign.right,
                              decoration: const InputDecoration(
                                labelText: 'עיר',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty ? 'נא להזין עיר' : null,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submitAndNavigate,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text(
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
    super.dispose();
  }
}