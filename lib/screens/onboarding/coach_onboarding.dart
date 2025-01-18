import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import '../../state/onboarding_state.dart';

class CoachOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;  // Add this line

  const CoachOnboarding({super.key, required this.userId, required this.onboardingState,});

  @override
  State<CoachOnboarding> createState() => _CoachOnboardingState();
}

class _CoachOnboardingState extends State<CoachOnboarding> {
  late String _userId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _certificateNumberController = TextEditingController();
  bool _isTeamValid = true;
  bool _isProfessionalCoach = false;
  PlatformFile? _selectedFile;
  
  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    debugPrint('CoachOnboarding initialized with userId: $_userId');
  }

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      
      final teamName = _teamNameController.text.trim();
      final certificateNumber = _certificateNumberController.text.trim();

      AppLogger.info('Coach Onboarding form submitted');
      AppLogger.info('Team Name: $teamName');

      try {
        String? teamId;
        // Only get team ID if a team name was provided
        if (teamName.isNotEmpty) {
          teamId = await _getTeamIdByName(teamName);
          if (teamId == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('הקבוצה שהוזנה לא נמצאה במערכת')),
            );
            return;
          }
        }

        if (!mounted) return;

        // Insert into users table if not exists
        final userExists = await _checkUserExists(_userId);
        if (!userExists) {
          await Supabase.instance.client.from('users').insert({
            'id': _userId,
            'role': 'coach',
          });
        }

        String? certificateUrl;
        if (_selectedFile != null) {
          // Upload certificate to storage
          final String fileName = '${_userId}_certificate.${_selectedFile!.extension}';
          final fileBytes = _selectedFile!.bytes!;
          
          final storageResponse = await Supabase.instance.client
              .storage
              .from('certificates')
              .uploadBinary(
                fileName,
                fileBytes,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: true,
                ),
              );
              
          certificateUrl = Supabase.instance.client
              .storage
              .from('certificates')
              .getPublicUrl(fileName);
        }

        // Insert into coaches table using user_id as id
        await Supabase.instance.client
            .from('coaches')
            .insert({
              'id': _userId,
              'current_team_id': teamId,
              'is_professional': _isProfessionalCoach,
              'certificate_number': _isProfessionalCoach ? certificateNumber : null,
              'certificate_url': certificateUrl,
            });

        Navigator.pushReplacementNamed(
          context,
          '/onboarding/favorites',
          arguments: {
            'userId': _userId,
            'onboardingState': widget.onboardingState,
          },
        );
      } catch (e, stackTrace) {
        AppLogger.error('Error during coach onboarding', error: e, stackTrace: stackTrace);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
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

  Future<String?> _getTeamIdByName(String teamName) async {
    try {
      final response = await Supabase.instance.client
          .from('teams')
          .select('id')
          .eq('name', teamName)
          .limit(1)
          .single();

      return response['id'] as String?;
    } catch (e) {
      debugPrint('Error fetching team ID: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
                        'מאמן - שלב ההרשמה',
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
                            _buildTeamNameField(),
                            const SizedBox(height: 20),
                            _buildCertificationTypeField(),
                             const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submitAndNavigate,
                              child: const Text(
                                'המשך',
                                style: TextStyle(fontSize: 15),
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
          ],
        ),
      ),
    );
  }
  
  Widget _buildTeamNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'הקבוצה שלך: (אופציונלי)',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }

                  try {
                    final response = await Supabase.instance.client
                        .from('teams')
                        .select('name')
                        .ilike('name', '%${textEditingValue.text}%')
                        .limit(10);

                    final List<dynamic> data = response as List<dynamic>;
                    return data.map<String>((team) => team['name'] as String);
                  } catch (error) {
                    debugPrint('Error fetching teams: $error');
                    return const Iterable<String>.empty();
                  }
                },
                displayStringForOption: (String option) => option,
                onSelected: (String selection) {
                  setState(() {
                    _teamNameController.text = selection;
                    _isTeamValid = true;
                  });
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController fieldController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  return TextFormField(
                    controller: fieldController,
                    focusNode: fieldFocusNode,
                    decoration: const InputDecoration(
                      labelText: 'שם הקבוצה',
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: alternateThemeColor,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _isTeamValid = false;
                        });
                      }
                    },
                    validator: (value) {
                      if (value?.isNotEmpty == true && !_isTeamValid) {
                        return 'יש לבחור קבוצה מהרשימה';
                      }
                      return null;
                    },
                  );
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topRight,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width - 74,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(option),
                              onTap: () {
                                onSelected(option);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'השאר/י ריק במידה ואין לך קבוצה או שהקבוצה לא נמצאת',
          style: TextStyle(
            fontSize: 11,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildCertificationTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'סטטוס הסמכה:',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            ListTile(
              title: const Text('אין לי תעודת מאמנ/ת'),
              leading: Radio<bool>(
                value: false,
                groupValue: _isProfessionalCoach,
                onChanged: (bool? value) {
                  setState(() {
                    _isProfessionalCoach = false;
                    // Clear certificate fields when switching to non-professional
                    _certificateNumberController.clear();
                    _selectedFile = null;
                  });
                },
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            ListTile(
              title: const Text('אני מאמנ/ת במקצועי'),
              leading: Radio<bool>(
                value: true,
                groupValue: _isProfessionalCoach,
                onChanged: (bool? value) {
                  setState(() {
                    _isProfessionalCoach = true;
                  });
                },
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            if (_isProfessionalCoach) ... [
              const SizedBox(height: 16),
              TextFormField(
                controller: _certificateNumberController,
                decoration: const InputDecoration(
                  labelText: 'מספר תעודה:',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: alternateThemeColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                validator: (value) => value == null || value.isEmpty 
                  ? 'נא להזין מספר תעודה' 
                  : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'העלאה של צילום של תעודת האימון:',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 8),
              if (_selectedFile != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _selectedFile!.name,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                    ),
                  ),
                ),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file),
                label: const Text('בחירת קובץ'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }


}
