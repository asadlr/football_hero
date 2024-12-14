import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  final String userId;

  const OnboardingScreen({required this.userId, super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String? _selectedRole;
  XFile? _profilePhoto;

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePhoto = pickedFile;
      });
    }
  }

  Future<void> _submitOnboardingData() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final city = _cityController.text.trim();
    final role = _selectedRole;

    if (name.isEmpty || address.isEmpty || city.isEmpty || role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('נא למלא את כל השדות')),
      );
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('users')
          .update({
            'name': name,
            'address': address,
            'city': city,
            'role': role,
          })
          .eq('id', widget.userId);

      if (!mounted) return; // Check if widget is still mounted
      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה: ${response.error!.message}')),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('נתונים נשמרו בהצלחה')),
      );
    } catch (e) {
      if (!mounted) return; // Check if widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה בלתי צפויה: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('השלמת הרשמה')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'נא להשלים את הפרטים הבאים:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'שמך',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'סוג משתמש',
                  border: OutlineInputBorder(),
                ),
                value: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'player', child: Text('שחקן')),
                  DropdownMenuItem(value: 'parent', child: Text('הורה')),
                  DropdownMenuItem(value: 'coach', child: Text('מאמן')),
                  DropdownMenuItem(value: 'community', child: Text('צוות קהילתי')),
                  DropdownMenuItem(value: 'mentor', child: Text('מנטור')),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'כתובת',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'עיר',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickProfilePhoto,
                child: const Text('העלה תמונת פרופיל'),
              ),
              if (_profilePhoto != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('תמונה נבחרה: ${_profilePhoto!.name}'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitOnboardingData,
                child: const Text('שלח'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
