import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

class CoachOnboarding extends StatefulWidget {
  final String userId;

  const CoachOnboarding({super.key, required this.userId});

  @override
  State<CoachOnboarding> createState() => _CoachOnboardingState();
}

class _CoachOnboardingState extends State<CoachOnboarding> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _newTeamNameController = TextEditingController();

  bool _isSearchingTeamName = true;
  bool _isProfessionalCoach = false;
  bool _isLoading = false;
  bool _isUploadingFile = false;
  bool _isCreatingTeam = false;
  String? _newTeamName;

  Uint8List? _licenseFile;
  String? _licenseFileName;
  late String _userId;

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    debugPrint('CoachOnboarding initialized with userId: $_userId');
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickLicenseFile() async {
    if (_isUploadingFile) return;

    setState(() => _isUploadingFile = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _licenseFile = result.files.first.bytes;
          _licenseFileName = result.files.first.name;
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      _showSnackBar('שגיאה בבחירת הקובץ');
    } finally {
      setState(() => _isUploadingFile = false);
    }
  }

  Future<String?> _uploadLicenseFile() async {
    if (_licenseFile == null) return null;

    try {
      final filePath = 'coach_licenses/${_userId}_${DateTime.now().millisecondsSinceEpoch}';
      final response = await Supabase.instance.client
          .storage
          .from('licenses')
          .uploadBinary(
            filePath,
            _licenseFile!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return response;
    } catch (e) {
      debugPrint('Error uploading license file: $e');
      return null;
    }
  }


  Future<void> _submitAndNavigate() async {
    if (_isLoading || !_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user');
      }

      // Get or create team ID
      String? teamId;
      if (_isSearchingTeamName) {
        teamId = await _getTeamIdByName(_teamNameController.text.trim());
      } else if (_newTeamName != null) {
        // Create a new team if not searching
        final teamResponse = await Supabase.instance.client
            .from('teams')
            .insert({
              'name': _newTeamName,
              'status': 'pending',
              'created_by_id': _userId,
              'created_by_role': 'coach'
            })
            .select()
            .single();
        
        teamId = teamResponse['id'];
      }

      // Upsert coach record
      final coachResponse = await Supabase.instance.client
          .from('coaches')
          .upsert({
            'user_id': _userId,
            'phone_number': _phoneNumberController.text.trim(),
            'is_professional': _isProfessionalCoach,
            'license_number': _isProfessionalCoach ? _licenseNumberController.text : null,
            'license_file_url': _isProfessionalCoach && _licenseFile != null 
                ? await _uploadLicenseFile() 
                : null
          }, onConflict: 'user_id')
          .select()
          .single();

      // If a team was selected/created, add coach to team members
      if (teamId != null) {
        await Supabase.instance.client
            .from('team_members')
            .upsert({
              'team_id': teamId,
              'user_id': _userId,
              'role': 'coach',
              'status': 'pending'
            }, onConflict: 'team_id,user_id');
      }

      Navigator.pushReplacementNamed(
        context, 
        '/onboarding/favorites', 
        arguments: {'userId': _userId}
      );
    } catch (e) {
      debugPrint('Error during coach onboarding: $e');
      _showSnackBar('שגיאה בתהליך ההרשמה: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  Future<String?> _getTeamIdByName(String teamName) async {
    try {
      final response = await Supabase.instance.client
          .from('teams')
          .select('id')
          .eq('name', teamName)
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('מאמן - שלב ההרשמה'),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/mainBackground.webp', fit: BoxFit.cover),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildTeamNameField(),
                        const SizedBox(height: 10),
                        _buildPopupMessage(),
                        const SizedBox(height: 18),
                        _buildCoachTypeSelection(),
                        if (_isProfessionalCoach) ...[
                          _buildProfessionalCoachFields(),
                          const SizedBox(height: 18),
                        ],
                        _buildPhoneNumberField(),
                        const SizedBox(height: 18),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitAndNavigate,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('המשך', style: TextStyle(fontSize: 16.2)),
                        ),
                      ],
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

  Widget _buildTeamNameField() {
    return Row(
      children: [
        Radio<bool>(
          value: true,
          groupValue: _isSearchingTeamName,
          onChanged: (bool? value) {
            setState(() {
              _isSearchingTeamName = value!;
            });
          },
        ),
        const Text(
          'שם הקבוצה:',
          style: TextStyle(fontSize: 16.2),
        ),
        const SizedBox(width: 10),
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
                    .or(
                      'name.ilike.%${textEditingValue.text}%,'
                      'name.eq.${textEditingValue.text}'
                    )
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
                  labelText: 'הזן את שם הקבוצה',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: alternateThemeColor,
                ),
                validator: (value) {
                  if (_isSearchingTeamName && (value == null || value.isEmpty)) {
                    return 'נא להזין שם קבוצה';
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
    );
  }

  Widget _buildPopupMessage() {
    return Row(
      children: [
        Radio<bool>(
          value: false,
          groupValue: _isSearchingTeamName,
          onChanged: (bool? value) {
            setState(() {
              _isSearchingTeamName = value!;
            });
          },
        ),
        GestureDetector(
          onTap: () {
            _showCreateTeamDialog((String newTeamName) {
              debugPrint('New team created: $newTeamName');
              setState(() {
                _newTeamName = newTeamName;
                _isSearchingTeamName = false;
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _newTeamName == null
                ? const Text(
                    'אין לך עדיין קבוצה או שקבוצתך לא רשומה?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      'קבוצה חדשה: $_newTeamName',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showCreateTeamDialog(void Function(String) onTeamCreated) {
    final newTeamNameController = TextEditingController();
    final newTeamAddressController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('צור קבוצה חדשה'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: newTeamNameController,
                    decoration: const InputDecoration(
                      labelText: 'שם הקבוצה',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'נא להזין שם קבוצה' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newTeamAddressController,
                    decoration: const InputDecoration(
                      labelText: 'כתובת (לא חובה)',
                      border: OutlineInputBorder(),
                      helperText: 'הוספת כתובת תסייע באימות הקבוצה',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isCreatingTeam 
                  ? null 
                  : () async {
                      if (formKey.currentState?.validate() ?? false) {
                        final String teamName = newTeamNameController.text.trim();
                        final String addressText = newTeamAddressController.text.trim();
                        final String? teamAddress = addressText.isNotEmpty ? addressText : null;

                        await _saveNewTeam(teamName, teamAddress);
                        if (!mounted) return;
                        Navigator.of(context).pop();
                        onTeamCreated(teamName);
                      }
                    },
              child: _isCreatingTeam
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('שמירה'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveNewTeam(String teamName, String? teamAddress) async {
    if (_isCreatingTeam) return;

    setState(() {
      _isCreatingTeam = true;
    });

    try {
      if (_userId.isEmpty) {
        throw Exception('User ID not found. Please complete registration first.');
      }

      // Check how many teams this user has created
      final teamsQuery = await Supabase.instance.client
          .from('teams')
          .select('*')
          .eq('created_by_id', _userId);

      final teamCount = (teamsQuery as List).length;

      if (teamCount >= 5) {
        _showSnackBar('לא ניתן ליצור יותר מ-5 קבוצות');
        return;
      }

      // Check if team name already exists
      final existingTeam = await Supabase.instance.client
          .from('teams')
          .select('id')
          .eq('name', teamName)
          .maybeSingle();

      if (existingTeam != null) {
        // If team exists, modify the name
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        teamName = '$teamName $timestamp';
      }

      // Create new team
      final response = await Supabase.instance.client
          .from('teams')
          .insert({
            'name': teamName,
            'address': teamAddress,
            'status': 'pending',
            'created_by_id': _userId,
            'created_by_role': 'coach',
          })
          .select()
          .single();

      // Add creator as a team member
      await Supabase.instance.client
          .from('team_members')
          .insert({
            'team_id': response['id'],
            'user_id': _userId,
            'role': 'coach',
          });

      setState(() {
        _teamNameController.text = teamName;
        _newTeamName = teamName; // Update the new team name
      });

      _showSnackBar('הקבוצה נוצרה בהצלחה. שים לב שהקבוצה נמצאת בסטטוס ממתין לאימות');

    } catch (e) {
      debugPrint('Save team error: $e');
      String errorMessage = 'שגיאה ביצירת הקבוצה. נא לנסות שוב';
      if (e.toString().contains('unique_team_name')) {
        errorMessage = 'שם הקבוצה כבר קיים במערכת';
      }
      _showSnackBar(errorMessage);
    } finally {
      setState(() {
        _isCreatingTeam = false;
      });
    }
  }
  Widget _buildCoachTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Radio<bool>(
            value: false,
            groupValue: _isProfessionalCoach,
            onChanged: (value) => setState(() => _isProfessionalCoach = value!),
          ),
          title: const Text('אני מאמנ/ת את הקבוצה ללא תעודה'),
        ),
        ListTile(
          leading: Radio<bool>(
            value: true,
            groupValue: _isProfessionalCoach,
            onChanged: (value) => setState(() => _isProfessionalCoach = value!),
          ),
          title: const Text('אני מאמנ/ת במקצוע'),
        ),
      ],
    );
  }

  Widget _buildProfessionalCoachFields() {
    return Column(
      children: [
        TextFormField(
          controller: _licenseNumberController,
          decoration: const InputDecoration(
            labelText: 'מספר תעודת מאמן',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: alternateThemeColor,
          ),
          validator: (value) => value == null || value.isEmpty ? 'נא להזין מספר תעודת מאמן' : null,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _isUploadingFile ? null : _pickLicenseFile,
          icon: _isUploadingFile
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.upload_file),
          label: Text(_licenseFileName ?? 'העלאת תעודת מאמן'),
        ),
        if (_licenseFileName != null)
          Text(
            'קובץ נבחר: $_licenseFileName',
            style: const TextStyle(fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneNumberController,
      decoration: const InputDecoration(
        labelText: 'מספר טלפון',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: alternateThemeColor,
      ),
      keyboardType: TextInputType.phone,
      validator: (value) => value == null || value.isEmpty ? 'נא להזין מספר טלפון' : null,
    );
  }
}
