//lib\screens\onboarding\mentor_onboarding.dart

import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../state/onboarding_state.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../localization/app_strings.dart';
import '../../localization/localization_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _userId = widget.userId;
    _onboardingState = widget.onboardingState;
    _initializeFields();
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

    context.go('/onboarding', extra: {
      'userId': _userId,
      'onboardingState': updatedState,
    });
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
      AppLogger.error(message: 'Error fetching community ID');
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
              SnackBar(content: Text(AppStrings.get('community_not_found'))),
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

          AppLogger.info(message: 'Created mentor-community association');
        }

        // Update state
        final updatedState = _onboardingState.copyWith(
          idNumber: idNumber,
          communityName: communityName,
        );

        if (mounted) {
          context.go('/onboarding/favorites', extra: {
            'userId': _userId,
            'onboardingState': updatedState,
          });
        }
      } catch (e) {
        AppLogger.error(message: 'Error during mentor onboarding');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.get('unexpected_error'))),
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
                            AppStrings.get('mentor_registration_title'),
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
                                _buildIdNumberField(theme),
                                const SizedBox(height: ThemeConstants.md),
                                _buildCommunityNameField(theme),
                                const SizedBox(height: ThemeConstants.md),
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
                        color: AppColors.mentorColor,
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

  Widget _buildIdNumberField(ThemeData theme) {
    if (!_isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.mentorColor,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('personal_id_label'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: ThemeConstants.sm),
        TextFormField(
          controller: _idNumberController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            isDense: true,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppStrings.get('personal_id_required');
            }
            if (value.length != 9) {
              return AppStrings.get('personal_id_length');
            }
            return null;
          },
          keyboardType: TextInputType.number,
          maxLength: 9,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCommunityNameField(ThemeData theme) {
    if (!_isInitialized) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.mentorColor,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('your_community'),
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: ThemeConstants.sm),
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
              AppLogger.error(message: 'Error fetching communities');
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
              decoration: InputDecoration(
                labelText: AppStrings.get('community_name'),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  return AppStrings.get('select_community_from_list');
                }
                return null;
              },
              style: theme.textTheme.bodyMedium,
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
        const SizedBox(height: ThemeConstants.sm),
        Text(
          AppStrings.get('leave_empty_if_no_community'),
          style: theme.textTheme.bodySmall,
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