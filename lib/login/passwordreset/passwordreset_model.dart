import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'passwordreset_widget.dart' show PasswordresetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordresetModel extends FlutterFlowModel<PasswordresetWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for newPassword widget.
  FocusNode? newPasswordFocusNode;
  TextEditingController? newPasswordTextController;
  late bool newPasswordVisibility;
  String? Function(BuildContext, String?)? newPasswordTextControllerValidator;
  // State field(s) for confirmNewPassword widget.
  FocusNode? confirmNewPasswordFocusNode;
  TextEditingController? confirmNewPasswordTextController;
  late bool confirmNewPasswordVisibility;
  String? Function(BuildContext, String?)?
      confirmNewPasswordTextControllerValidator;
  // Stores action output result for [Custom Action - resetPassword] action in setNewPassword widget.
  String? error;

  @override
  void initState(BuildContext context) {
    newPasswordVisibility = false;
    confirmNewPasswordVisibility = false;
  }

  @override
  void dispose() {
    newPasswordFocusNode?.dispose();
    newPasswordTextController?.dispose();

    confirmNewPasswordFocusNode?.dispose();
    confirmNewPasswordTextController?.dispose();
  }
}
