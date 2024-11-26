import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'add_email_widget.dart' show AddEmailWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddEmailModel extends FlutterFlowModel<AddEmailWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for parentEmail widget.
  FocusNode? parentEmailFocusNode;
  TextEditingController? parentEmailTextController;
  String? Function(BuildContext, String?)? parentEmailTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    parentEmailFocusNode?.dispose();
    parentEmailTextController?.dispose();
  }
}
