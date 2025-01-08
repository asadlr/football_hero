import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../logger/logger.dart';

class Onboarding extends StatefulWidget {
  final String userId;

  const Onboarding({
    super.key,
    required this.userId,
  });

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Add this line to your state variables at the top
  late String userId;

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
    userId = widget.userId;  // Initialize from widget property
    debugPrint('Onboarding initialized with userId: $userId');
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

        if (!mounted) return;
        AppLogger.info('Navigating based on role: $role');
        _navigateBasedOnRole(role);
      } catch (e, stackTrace) {
        AppLogger.error('Error saving user data', error: e, stackTrace: stackTrace);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה: $e')),
        );
      }
    }
  }

  void _navigateBasedOnRole(String? role) {
    if (role == null) {
      AppLogger.warning('No role selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('סוג משתמש לא נבחר')),
      );
      return;
    }

    switch (role) {
      case 'player':
        Navigator.pushReplacementNamed(
          context,
          '/onboarding/player',
          arguments: {'userId': userId, 'role': role},
        );
        break;

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
        _dobController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
      AppLogger.info('Date selected: $pickedDate');
    } else {
      AppLogger.warning('Date picker canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                            textAlign: TextAlign.right,
                            decoration: const InputDecoration(
                              labelText: 'שמך',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty
                                    ? 'נא להזין שם'
                                    : null,
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
                                value == null || value.isEmpty
                                    ? 'נא לבחור תאריך לידה'
                                    : null,
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'סוג משתמש',
                              border: OutlineInputBorder(),
                            ),
                            value: _selectedRole,
                            onChanged: (value) =>
                                setState(() => _selectedRole = value),
                            items: const [
                              DropdownMenuItem(
                                  value: 'player', child: Text('שחקן')),
                              DropdownMenuItem(
                                  value: 'parent', child: Text('הורה')),
                              DropdownMenuItem(
                                  value: 'coach', child: Text('מאמן')),
                              DropdownMenuItem(
                                  value: 'community',
                                  child: Text('צוות קהילתי')),
                              DropdownMenuItem(
                                  value: 'mentor', child: Text('מנטור')),
                            ],
                            validator: (value) =>
                                value == null ? 'נא לבחור סוג משתמש' : null,
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
                                value == null || value.isEmpty
                                    ? 'נא להזין כתובת'
                                    : null,
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
                                value == null || value.isEmpty
                                    ? 'נא להזין עיר'
                                    : null,
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
    );
  }
}
