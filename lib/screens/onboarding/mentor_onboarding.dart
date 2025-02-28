import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/onboarding_state.dart';

class MentorOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;

  const MentorOnboarding({
    super.key,
    required this.userId,
    required this.onboardingState,
  });

  @override
  State<MentorOnboarding> createState() => _MentorOnboardingState();
}

class _MentorOnboardingState extends State<MentorOnboarding> {
  late String _userId;
  late OnboardingState _onboardingState;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _communityNameController = TextEditingController();
  bool _isCommunityValid = true;
  bool _isInitialized = false;

  static const Color alternateThemeColor = Color(0xFFE0E3E7);

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
    debugPrint('MentorOnboarding initialized with userId: $_userId');
  }

  void _initializeFields() {
    _idNumberController.text = _onboardingState.idNumber ?? '';
    _communityNameController.text = _onboardingState.communityName ?? '';

    setState(() {
      _isInitialized = true;
    });
  }

  void _handleBack() {
    final updatedState = _onboardingState.copyWith(
      idNumber: _idNumberController.text.trim(),
      communityName: _communityNameController.text.trim(),
    );

    Navigator.pushReplacementNamed(
      context,
      '/onboarding',
      arguments: {
        'userId': _userId,
        'onboardingState': updatedState,
      },
    );
  }

  Future<String?> _getCommunityByName(String communityName) async {
    try {
      final response = await Supabase.instance.client
          .from('communities')
          .select('id')
          .eq('name', communityName)
          .limit(1)
          .single();

      return response['id'] as String?;
    } catch (e) {
      debugPrint('Error fetching community ID: $e');
      return null;
    }
  }

  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final idNumber = _idNumberController.text.trim();
        final communityName = _communityNameController.text.trim();

        // Update personal_id in the users table
        await Supabase.instance.client
            .from('users')
            .update({'personal_id': idNumber})
            .eq('id', _userId);

        if (communityName.isNotEmpty) {
          // Get the community ID
          final communityId = await _getCommunityByName(communityName);
          if (communityId == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('הקהילה שהוזנה לא נמצאה במערכת')),
            );
            setState(() {
              _isLoading = false;
            });
            return;
          }

          // Associate mentor with community
          await Supabase.instance.client
              .from('mentor_communities')
              .upsert({
                'mentor_id': _userId,
                'community_id': communityId,
                'status': 'pending',
                'created_by': _userId,
                'approved_by': null,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': DateTime.now().toIso8601String(),
              });

          AppLogger.info('Created mentor-community association');
        }

        // Update state
        final updatedState = _onboardingState.copyWith(
          idNumber: idNumber,
          communityName: communityName,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            '/onboarding/favorites',
            arguments: {
              'userId': _userId,
              'onboardingState': updatedState,
            },
          );
        }
      } catch (e, stackTrace) {
        AppLogger.error('Error during mentor onboarding', error: e, stackTrace: stackTrace);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $e')),
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
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope(
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
              onPressed: () {
                _handleBack();
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
                          'מנטור - שלב ההרשמה',
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
                              _buildIdNumberField(),
                              const SizedBox(height: 20),
                              _buildCommunityNameField(),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _isLoading ? null : _submitAndNavigate,
                                child: _isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('המשך'),
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
                const Positioned.fill(
                  child: ColoredBox(
                    color: Colors.black26,
                    child: Center(
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

  Widget _buildIdNumberField() {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'מספר תעודת זהות:',
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _idNumberController,
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

  Widget _buildCommunityNameField() {
  if (!_isInitialized) {
    return const Center(child: CircularProgressIndicator());
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'הקהילה שלך:',
        style: TextStyle(fontSize: 15),
      ),
      const SizedBox(height: 10),
      Autocomplete<String>(
        initialValue: TextEditingValue(text: _communityNameController.text),
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }

          try {
            final response = await Supabase.instance.client
                .from('communities')
                .select('name')
                .ilike('name', '%${textEditingValue.text}%')
                .limit(10);

            if (response == null) {
              return const Iterable<String>.empty();
            }

            if (response is! List) {
              return const Iterable<String>.empty();
            }

            return response.map<String>((item) => item['name'].toString());

          } catch (error) {
            debugPrint('Error fetching communities: $error');
            return const Iterable<String>.empty();
          }
        },
        displayStringForOption: (String option) => option,
        onSelected: (String selection) {
          setState(() {
            _communityNameController.text = selection;
            _isCommunityValid = true;
          });
        },
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController fieldController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted,
        ) {
          if (fieldController.text != _communityNameController.text) {
            fieldController.text = _communityNameController.text;
          }

          return TextFormField(
            controller: fieldController,
            focusNode: fieldFocusNode,
            decoration: const InputDecoration(
              labelText: 'שם הקהילה',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: alternateThemeColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            onChanged: (value) {
              _communityNameController.text = value;
              if (value.isNotEmpty) {
                setState(() {
                  _isCommunityValid = false;
                });
              } else {
                setState(() {
                  _isCommunityValid = true;  // Empty value is valid
                });
              }
            },
            validator: (value) {
              if (value?.isNotEmpty == true && !_isCommunityValid) {
                return 'יש לבחור קהילה מהרשימה';
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
      const SizedBox(height: 8),
      const Text(
        'השאר/י ריק במידה ואין לך קהילה או שהקהילה לא נמצאת',
        style: TextStyle(
          fontSize: 11,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
      ),
    ],
  );
}


  @override
  void dispose() {
    _idNumberController.dispose();
    _communityNameController.dispose();
    super.dispose();
  }
}