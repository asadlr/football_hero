import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'password_reset_screen_widget.dart' show PasswordResetScreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordResetScreenModel
    extends FlutterFlowModel<PasswordResetScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for usernameLogin widget.
  FocusNode? usernameLoginFocusNode;
  TextEditingController? usernameLoginTextController;
  String? Function(BuildContext, String?)? usernameLoginTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    usernameLoginFocusNode?.dispose();
    usernameLoginTextController?.dispose();
  }
}
