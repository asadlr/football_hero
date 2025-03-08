import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../state/onboarding_state.dart';


class CoachOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;

  const CoachOnboarding({super.key, required this.userId, required this.onboardingState,});

  @override
  State<CoachOnboarding> createState() => _CoachOnboardingState();
}

class _CoachOnboardingState extends State<CoachOnboarding> {
  late String _userId;
  late OnboardingState _onboardingState;  
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _certificateNumberController = TextEditingController();
  bool _isTeamValid = true;
  bool _isProfessionalCoach = false;
  PlatformFile? _selectedFile;
  String? _savedFileName;
  String? _savedFileUrl;
  bool _isInitialized = false;
  
  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
  } 

  void _initializeFields() async {
    // Pre-fill fields from the onboardingState
    _isProfessionalCoach = _onboardingState.isProfessionalCoach ?? false;
    _certificateNumberController.text = _onboardingState.certificateNumber ?? '';
    
    // Initialize file information
    _savedFileName = _onboardingState.certificateFileName;
    _savedFileUrl = _onboardingState.certificateUrl;

    // If we have saved file info, update the UI
    if (_savedFileName != null) {
      setState(() {
        _selectedFile = PlatformFile(
          name: _savedFileName!,
          size: 0,  // Size isn't critical for display
          bytes: null,  // We don't need the actual bytes for display
        );
      });
    }

    // Handle team name initialization
    final savedTeamName = _onboardingState.teamName;
      if (savedTeamName != null && savedTeamName.isNotEmpty) {
        _teamNameController.text = savedTeamName;
        // Verify team exists
        try {
          final exists = await _verifyTeamExists(savedTeamName);
          if (mounted) {
            setState(() {
              _isTeamValid = exists;
              _isInitialized = true;
            });
          }
        } catch (e) {
          AppLogger.error('Error verifying team');
          if (mounted) {
            setState(() {
              _isTeamValid = false;
              _isInitialized = true;
            });
          }
        }
      } else {
        setState(() {
          _isInitialized = true;
        });
      }
    }

  Future<bool> _verifyTeamExists(String teamName) async {
    try {
      final response = await Supabase.instance.client
          .from('teams')
          .select('name')
          .eq('name', teamName)
          .maybeSingle();
      return response != null;
    } catch (e) {
      AppLogger.error('Error verifying team');
      return false;
    }
  }
  
  void _handleBack() {
    // Update the onboardingState with all current form data
    final updatedState = _onboardingState.copyWith(
      teamName: _teamNameController.text.trim(),
      isProfessionalCoach: _isProfessionalCoach,
      certificateNumber: _isProfessionalCoach ? _certificateNumberController.text.trim() : null,
      certificateFileName: _selectedFile?.name ?? _savedFileName,
      certificateUrl: _savedFileUrl,
    );

    // Use GoRouter instead of Navigator
    context.go('/onboarding', extra: {
      'userId': _userId,
      'onboardingState': updatedState,
    });
  }
  
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
      AppLogger.error('Error picking file');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('אירעה שגיאה בבחירת הקובץ. אנא נסה שוב.')),
        );
      }
    }
  }

  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final teamName = _teamNameController.text.trim();
        final certificateNumber = _certificateNumberController.text.trim();
        String? certificateUrl;
        String? fileName;

        // Handle file upload if there's a new file
        if (_selectedFile?.bytes != null) {
          // Create a path that includes the user ID as a folder
          fileName = '${_userId}/${_userId}_certificate.${_selectedFile!.extension}';
          final fileBytes = _selectedFile!.bytes!;

          await Supabase.instance.client
              .storage
              .from('coach_certificate')
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
              .from('coach_certificate')
              .getPublicUrl(fileName);
        }

        String? teamId;
        // Only get team ID if a team name was provided
        if (teamName.isNotEmpty) {
          teamId = await _getTeamIdByName(teamName);
          if (teamId == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('הקבוצה שהוזנה לא נמצאה במערכת')),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }

        if (!mounted) return;

        // Update coach-specific fields directly in the users table
        await Supabase.instance.client
            .from('users')
            .update({
              'is_professional': _isProfessionalCoach,
              'certificate_number': _isProfessionalCoach ? certificateNumber : null,
              'certificate_url': certificateUrl ?? _savedFileUrl,
            })
            .eq('id', _userId);
        
        // Handle team association if a team was selected
        if (teamId != null) {
          try {
            await Supabase.instance.client
              .from('team_members')
              .insert({
                'user_id': _userId,
                'team_id': teamId,
                'role': 'coach',
                'status': 'pending',
                'created_at': DateTime.now().toIso8601String(),
                'created_by': _userId
              });
          } catch (teamError) {
            AppLogger.error('Error associating coach with team');
            // Don't rethrow since this isn't critical to proceed
          }
        }

        // Update state with all information including file data
        final updatedState = _onboardingState.copyWith(
          teamName: teamName,
          isProfessionalCoach: _isProfessionalCoach,
          certificateNumber: _isProfessionalCoach ? certificateNumber : null,
          certificateFileName: fileName ?? _savedFileName,
          certificateUrl: certificateUrl ?? _savedFileUrl,
        );

        if (mounted) {
          context.go('/onboarding/favorites', extra: {
            'userId': _userId,
            'onboardingState': updatedState,
          });
        }
      } catch (e) {
        AppLogger.error('Error during coach onboarding');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('אירעה שגיאה בעיבוד הבקשה. אנא נסה שוב.')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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
      AppLogger.error('Error fetching team ID');
      return null;
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

  Widget _buildTeamNameField() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

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
                initialValue: TextEditingValue(text: _teamNameController.text),
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
                    AppLogger.error('Error fetching teams');
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
                  // Sync the controllers
                  if (fieldController.text != _teamNameController.text) {
                    fieldController.text = _teamNameController.text;
                  }

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
                      _teamNameController.text = value;
                      if (value.isNotEmpty) {
                        setState(() {
                          _isTeamValid = false;
                        });
                      } else {
                        setState(() {
                          _isTeamValid = true;  // Empty value is valid
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
                    // But keeping certificate fields when switching to non-professional
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
            if (_isProfessionalCoach) ...[
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
              if (_selectedFile != null || _savedFileUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedFile?.name ?? _savedFileName ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      if (_savedFileUrl != null)
                        TextButton(
                          onPressed: () {
                            // You could add functionality to view the saved file
                            // For now, just show that it exists
                          },
                          child: const Text('קובץ קיים'),
                        ),
                    ],
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

  @override
  void dispose() {
    _teamNameController.dispose();
    _certificateNumberController.dispose();
    super.dispose();
  }
}