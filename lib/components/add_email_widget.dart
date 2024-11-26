import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_email_model.dart';
export 'add_email_model.dart';

class AddEmailWidget extends StatefulWidget {
  const AddEmailWidget({
    super.key,
    required this.email,
  });

  final String? email;

  @override
  State<AddEmailWidget> createState() => _AddEmailWidgetState();
}

class _AddEmailWidgetState extends State<AddEmailWidget> {
  late AddEmailModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddEmailModel());

    _model.parentEmailTextController ??= TextEditingController();
    _model.parentEmailFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Container(
              width: MediaQuery.sizeOf(context).width * 0.9,
              height: MediaQuery.sizeOf(context).height * 0.9,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'It looks like your age is under 13.\nPlease enter your parent\'s email.',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Combo',
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                        ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width * 0.85,
                    child: TextFormField(
                      controller: _model.parentEmailTextController,
                      focusNode: _model.parentEmailFocusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.go,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintStyle:
                            FlutterFlowTheme.of(context).bodyLarge.override(
                                  fontFamily: 'Combo',
                                  letterSpacing: 0.0,
                                ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x00000000),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).alternate,
                      ),
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Outfit',
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                          ),
                      validator: _model.parentEmailTextControllerValidator
                          .asValidator(context),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: FFButtonWidget(
                      onPressed: () {
                        print('Login pressed ...');
                      },
                      text: 'OK',
                      options: FFButtonOptions(
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        height: 40.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Combo',
                                  fontSize: 22.0,
                                  letterSpacing: 0.0,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 20.0)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
