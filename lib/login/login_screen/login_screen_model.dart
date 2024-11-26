import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for usernameLogin widget.
  FocusNode? usernameLoginFocusNode;
  TextEditingController? usernameLoginTextController;
  String? Function(BuildContext, String?)? usernameLoginTextControllerValidator;
  // State field(s) for passwordLogin widget.
  FocusNode? passwordLoginFocusNode;
  TextEditingController? passwordLoginTextController;
  late bool passwordLoginVisibility;
  String? Function(BuildContext, String?)? passwordLoginTextControllerValidator;

  @override
  void initState(BuildContext context) {
    passwordLoginVisibility = false;
  }

  @override
  void dispose() {
    usernameLoginFocusNode?.dispose();
    usernameLoginTextController?.dispose();

    passwordLoginFocusNode?.dispose();
    passwordLoginTextController?.dispose();
  }
}
