//lib\screens\onboarding\player_onboarding.dart
//lib\screens\onboarding\player_onboarding.dart

import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/onboarding_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../localization/app_strings.dart';
import '../../localization/localization_manager.dart';

class PlayerOnboarding extends StatefulWidget {
  final String userId;
  final OnboardingState onboardingState;
  const PlayerOnboarding({super.key, required this.userId, required this.onboardingState});

  @override
  State<PlayerOnboarding> createState() => _PlayerOnboardingState();
}

class _PlayerOnboardingState extends State<PlayerOnboarding> {
  late String _userId;
  late OnboardingState _onboardingState;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final Set<String> _selectedPositions = {};
  String? _selectedLeg;
  double _speed = 0;
  double _headers = 0;
  double _defending = 0;
  double _passing = 0;
  double _scoring = 0;
  double _goalkeeping = 0;
  bool _isTeamValid = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
  }

  void _initializeFields() {
    // Pre-fill fields from the onboardingState
    _teamNameController.text = _onboardingState.teamName ?? '';
    _heightController.text = _onboardingState.height?.toString() ?? '';
    _weightController.text = _onboardingState.weight?.toString() ?? '';
    _selectedPositions.addAll(_onboardingState.positions ?? []);
    _selectedLeg = _onboardingState.strongLeg;
    final skills = _onboardingState.skills;
    if (skills != null) {
      _speed = skills.speed;
      _headers = skills.headers;
      _defending = skills.defending;
      _passing = skills.passing;
      _scoring = skills.scoring;
      _goalkeeping = skills.goalkeeping;
    }
  }

  void _handleBack() {
    // Update the onboardingState with the current form data
    final updatedState = _onboardingState.copyWith(
      teamName: _teamNameController.text.trim(),
      height: int.tryParse(_heightController.text.trim()),
      weight: int.tryParse(_weightController.text.trim()),
      positions: _selectedPositions.toList(),
      strongLeg: _selectedLeg,
      skills: PlayerSkills(
        speed: _speed,
        headers: _headers,
        defending: _defending,
        passing: _passing,
        scoring: _scoring,
        goalkeeping: _goalkeeping,
      ),
    );

    context.go('/onboarding', extra: {
      'userId': _userId,
      'onboardingState': updatedState,
    });
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
      AppLogger.error(message: 'Error fetching team ID');
      return null;
    }
  }
  
  Future<void> _submitAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final teamName = _teamNameController.text.trim();
      final height = int.tryParse(_heightController.text.trim());
      final weight = int.tryParse(_weightController.text.trim());
      final positions = _selectedPositions.toList();
      final strongLeg = _selectedLeg;

      // Create the PlayerSkills object
      final skills = PlayerSkills(
        speed: _speed,
        headers: _headers,
        defending: _defending,
        passing: _passing,
        scoring: _scoring,
        goalkeeping: _goalkeeping,
      );

      // Create updated state BEFORE navigation
      final updatedState = _onboardingState.copyWith(
        teamName: teamName,
        height: height,
        weight: weight,
        positions: positions,
        strongLeg: strongLeg,
        skills: skills,
      );

      AppLogger.info(message: 'Player Onboarding form submitted');

      try {
        String? teamId;
        // Only get team ID if a team name was provided
        if (teamName.isNotEmpty) {
          teamId = await _getTeamIdByName(teamName);
          if (teamId == null) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.get('team_not_found'))),
            );
            setState(() {
              _isLoading = false;
            });
            return; // Stop the submission process here
          }
        }

        if (!mounted) return;

        // Try to use existing players table first
        try {
          await Supabase.instance.client
            .from('players')
            .insert({
              'id': _userId,
              'height': height,
              'weight': weight,
              'positions': positions,
              'strong_leg': strongLeg,
              'skills': jsonEncode(skills.toMap()), // Encode the PlayerSkills object to a Map
            });
        } catch (playerInsertError) {
          AppLogger.warning(message: 'Could not insert into players table, possibly removed. Storing player data in metadata');
          
          // If players table is gone, store the data as metadata in a JSON field in users table
          final Map<String, dynamic> playerMetadata = {
            'height': height,
            'weight': weight,
            'positions': positions,
            'strong_leg': strongLeg,
            'skills': skills.toMap(),
          };
          
          await Supabase.instance.client
            .from('users')
            .update({
              'player_metadata': playerMetadata
            })
            .eq('id', _userId);
        }

        if (teamId != null) {
          try {
            // Insert using composite key approach
            await Supabase.instance.client
              .from('team_members')
              .insert({
                'user_id': _userId,
                'team_id': teamId,
                'role': 'player',
                'status': 'pending'
              });
          } catch (teamMemberError) {
            AppLogger.error(message: 'Error adding user to team');
            // Don't rethrow, since joining a team is not critical to continue
          }
        }
        
        if (mounted) {
          context.go('/onboarding/favorites', extra: {
            'userId': _userId,
            'onboardingState': updatedState,
          });
        }
      } catch (e) {
        AppLogger.error(message: 'Error during player onboarding');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.get('unexpected_error'))),
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
                            AppStrings.get('player_registration_title'),
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
                                _buildTeamNameField(theme),
                                const SizedBox(height: ThemeConstants.xs),
                                _buildPositionSelection(theme),
                                const SizedBox(height: ThemeConstants.sm),
                                _buildHeightWeightFields(theme),
                                const SizedBox(height: ThemeConstants.sm),
                                _buildLegSelection(theme),
                                const SizedBox(height: ThemeConstants.sm),
                                _buildSkillsSliders(theme),
                                const SizedBox(height: ThemeConstants.sm),
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
  
  Widget _buildTeamNameField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('your_team_optional'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: ThemeConstants.sm),
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
                    AppLogger.error(message: 'Error fetching teams');
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
                  // Keep a reference to the autocomplete controller
                  // This allows us to sync it with _teamNameController
                  if (fieldController.text != _teamNameController.text) {
                    fieldController.text = _teamNameController.text;
                  }
                  
                  return TextFormField(
                    controller: fieldController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      labelText: AppStrings.get('team_name'),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                    ),
                    onChanged: (value) async {
                      // Update our main controller
                      _teamNameController.text = value;
                      
                      if (value.isEmpty) {
                        setState(() {
                          _isTeamValid = true; // Empty is valid for optional field
                        });
                        return;
                      }
                      
                      // Only validate if the text has a reasonable length
                      if (value.length >= 3) {
                        try {
                          // Check if team exists with exact name match
                          final exactMatch = await Supabase.instance.client
                              .from('teams')
                              .select('name')
                              .eq('name', value)
                              .limit(1);
                          
                          setState(() {
                            // If we get any results back, the team exists
                            _isTeamValid = exactMatch != null && exactMatch.isNotEmpty;
                          });
                        } catch (error) {
                          AppLogger.error(message: 'Error validating team');
                          setState(() {
                            _isTeamValid = false;
                          });
                        }
                      } else {
                        setState(() {
                          _isTeamValid = false;
                        });
                      }
                    },
                    validator: (value) {
                      if (value?.isEmpty == true) {
                        return null; // Optional field can be empty
                      }
                      if (!_isTeamValid) {
                        return AppStrings.get('select_team_from_list');
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
        Text(
          AppStrings.get('leave_empty_if_no_team'),
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPositionSelection(ThemeData theme) {
    final positions = [
      {'label': AppStrings.get('position_goalkeeper'), 'value': 'goalkeeper'},
      {'label': AppStrings.get('position_defense'), 'value': 'defense'},
      {'label': AppStrings.get('position_midfield'), 'value': 'midfield'},
      {'label': AppStrings.get('position_offense'), 'value': 'offense'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('position_label'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: ThemeConstants.sm),
        Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 10,
            children: positions.map((position) {
              return FilterChip(
                label: Text(
                  position['label']!,
                  style: theme.textTheme.bodySmall,
                ),
                selected: _selectedPositions.contains(position['value']),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedPositions.add(position['value']!);
                    } else {
                      _selectedPositions.remove(position['value']!);
                    }
                  });
                },
                backgroundColor: AppColors.background,
                selectedColor: AppColors.playerColor.withOpacity(0.2),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHeightWeightFields(ThemeData theme) {
    return Row(
      children: [
        Text(AppStrings.get('height_label'), style: theme.textTheme.bodyLarge),
        Expanded(
          child: _buildTextFormField(
            theme: theme,
            controller: _heightController,
            labelText: AppStrings.get('height_unit'),
            validatorMessage: AppStrings.get('enter_height'),
          ),
        ),
        const SizedBox(width: ThemeConstants.sm),
        Text(AppStrings.get('weight_label'), style: theme.textTheme.bodyLarge),
        Expanded(
          child: _buildTextFormField(
            theme: theme,
            controller: _weightController,
            labelText: AppStrings.get('weight_unit'),
            validatorMessage: AppStrings.get('enter_weight'),
          ),
        ),
      ],
    );
  }

  Widget _buildLegSelection(ThemeData theme) {
    return Row(
      children: [
        Text(
          AppStrings.get('strong_leg'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(width: ThemeConstants.sm),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedLeg,
            items: [
              DropdownMenuItem(value: 'right', child: Text(AppStrings.get('right_leg'))),
              DropdownMenuItem(value: 'left', child: Text(AppStrings.get('left_leg'))),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLeg = value;
              });
            },
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            validator: (value) => value == null ? AppStrings.get('select_strong_leg') : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSliders(ThemeData theme) {
    final skills = [
      {'label': AppStrings.get('skill_speed'), 'value': _speed, 'setter': (double v) => _speed = v},
      {'label': AppStrings.get('skill_headers'), 'value': _headers, 'setter': (double v) => _headers = v},
      {'label': AppStrings.get('skill_defending'), 'value': _defending, 'setter': (double v) => _defending = v},
      {'label': AppStrings.get('skill_passing'), 'value': _passing, 'setter': (double v) => _passing = v},
      {'label': AppStrings.get('skill_scoring'), 'value': _scoring, 'setter': (double v) => _scoring = v},
      {'label': AppStrings.get('skill_goalkeeping'), 'value': _goalkeeping, 'setter': (double v) => _goalkeeping = v},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: skills.map((skill) => _buildSlider(
        theme,
        skill['label'] as String,
        skill['value'] as double,
        (value) => setState(() => (skill['setter'] as Function(double))(value)),
      )).toList(),
    );
  }

  Widget _buildSlider(ThemeData theme, String label, double value, ValueChanged<double> onChanged) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: ThemeConstants.xs),
          child: Text(
            label,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        SizedBox(
          height: 30,
          child: Slider(
            value: value,
            min: 0,
            max: 10,
            divisions: 10,
            label: value.round().toString(),
            onChanged: onChanged,
            activeColor: AppColors.playerColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required ThemeData theme,
    required TextEditingController controller,
    required String labelText,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? validatorMessage : null,
      style: theme.textTheme.bodyMedium,
    );
  }
  
  @override
  void dispose() {
    _teamNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}