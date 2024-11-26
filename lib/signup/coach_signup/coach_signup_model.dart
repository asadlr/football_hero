import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'coach_signup_widget.dart' show CoachSignupWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CoachSignupModel extends FlutterFlowModel<CoachSignupWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for coachName widget.
  FocusNode? coachNameFocusNode;
  TextEditingController? coachNameTextController;
  String? Function(BuildContext, String?)? coachNameTextControllerValidator;
  // State field(s) for coachEmail widget.
  FocusNode? coachEmailFocusNode;
  TextEditingController? coachEmailTextController;
  String? Function(BuildContext, String?)? coachEmailTextControllerValidator;
  // State field(s) for coachNumber widget.
  FocusNode? coachNumberFocusNode;
  TextEditingController? coachNumberTextController;
  String? Function(BuildContext, String?)? coachNumberTextControllerValidator;
  // State field(s) for coachNewPassword widget.
  FocusNode? coachNewPasswordFocusNode;
  TextEditingController? coachNewPasswordTextController;
  late bool coachNewPasswordVisibility;
  String? Function(BuildContext, String?)?
      coachNewPasswordTextControllerValidator;
  // State field(s) for coachConfirmPassword widget.
  FocusNode? coachConfirmPasswordFocusNode;
  TextEditingController? coachConfirmPasswordTextController;
  late bool coachConfirmPasswordVisibility;
  String? Function(BuildContext, String?)?
      coachConfirmPasswordTextControllerValidator;

  @override
  void initState(BuildContext context) {
    coachNewPasswordVisibility = false;
    coachConfirmPasswordVisibility = false;
  }

  @override
  void dispose() {
    coachNameFocusNode?.dispose();
    coachNameTextController?.dispose();

    coachEmailFocusNode?.dispose();
    coachEmailTextController?.dispose();

    coachNumberFocusNode?.dispose();
    coachNumberTextController?.dispose();

    coachNewPasswordFocusNode?.dispose();
    coachNewPasswordTextController?.dispose();

    coachConfirmPasswordFocusNode?.dispose();
    coachConfirmPasswordTextController?.dispose();
  }
}
