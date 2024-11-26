import '/auth/supabase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'coach_signup_model.dart';
export 'coach_signup_model.dart';

class CoachSignupWidget extends StatefulWidget {
  const CoachSignupWidget({super.key});

  @override
  State<CoachSignupWidget> createState() => _CoachSignupWidgetState();
}

class _CoachSignupWidgetState extends State<CoachSignupWidget> {
  late CoachSignupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CoachSignupModel());

    _model.coachNameTextController ??= TextEditingController();
    _model.coachNameFocusNode ??= FocusNode();

    _model.coachEmailTextController ??= TextEditingController();
    _model.coachEmailFocusNode ??= FocusNode();

    _model.coachNumberTextController ??= TextEditingController();
    _model.coachNumberFocusNode ??= FocusNode();

    _model.coachNewPasswordTextController ??= TextEditingController();
    _model.coachNewPasswordFocusNode ??= FocusNode();

    _model.coachConfirmPasswordTextController ??= TextEditingController();
    _model.coachConfirmPasswordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Stack(
            alignment: AlignmentDirectional(0.0, -1.0),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/mainBackground.webp',
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 1.0,
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/images/SmallLogo.png',
                    width: 300.0,
                    height: 172.0,
                    fit: BoxFit.contain,
                    alignment: Alignment(0.0, 0.0),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.88,
                      height: MediaQuery.sizeOf(context).height * 0.72,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(32.0, 32.0, 32.0, 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Text(
                          'Create your coach account',
                          style: FlutterFlowTheme.of(context)
                              .displaySmall
                              .override(
                                fontFamily: 'Combo',
                                color: Colors.black,
                                fontSize: 29.0,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                      Container(
                        width: 370.0,
                        child: TextFormField(
                          controller: _model.coachNameTextController,
                          focusNode: _model.coachNameFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Name',
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
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Outfit',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model.coachNameTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                      Container(
                        width: 370.0,
                        child: TextFormField(
                          controller: _model.coachEmailTextController,
                          focusNode: _model.coachEmailFocusNode,
                          autofocus: true,
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
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Outfit',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model.coachEmailTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                      Container(
                        width: 370.0,
                        child: TextFormField(
                          controller: _model.coachNumberTextController,
                          focusNode: _model.coachNumberFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Coaching License Number',
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
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Outfit',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model.coachNumberTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                      Container(
                        width: 370.0,
                        child: TextFormField(
                          controller: _model.coachNewPasswordTextController,
                          focusNode: _model.coachNewPasswordFocusNode,
                          autofocus: true,
                          obscureText: !_model.coachNewPasswordVisibility,
                          decoration: InputDecoration(
                            labelText: 'Password',
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
                            suffixIcon: InkWell(
                              onTap: () => safeSetState(
                                () => _model.coachNewPasswordVisibility =
                                    !_model.coachNewPasswordVisibility,
                              ),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _model.coachNewPasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 22.0,
                              ),
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Outfit',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model
                              .coachNewPasswordTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                      Container(
                        width: 370.0,
                        child: TextFormField(
                          controller: _model.coachConfirmPasswordTextController,
                          focusNode: _model.coachConfirmPasswordFocusNode,
                          autofocus: true,
                          obscureText: !_model.coachConfirmPasswordVisibility,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                            suffixIcon: InkWell(
                              onTap: () => safeSetState(
                                () => _model.coachConfirmPasswordVisibility =
                                    !_model.coachConfirmPasswordVisibility,
                              ),
                              focusNode: FocusNode(skipTraversal: true),
                              child: Icon(
                                _model.coachConfirmPasswordVisibility
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 22.0,
                              ),
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    fontFamily: 'Outfit',
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model
                              .coachConfirmPasswordTextControllerValidator
                              .asValidator(context),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            GoRouter.of(context).prepareAuthEvent();
                            if (_model.coachNewPasswordTextController.text !=
                                _model
                                    .coachConfirmPasswordTextController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Passwords don\'t match!',
                                  ),
                                ),
                              );
                              return;
                            }

                            final user =
                                await authManager.createAccountWithEmail(
                              context,
                              _model.coachEmailTextController.text,
                              _model.coachNewPasswordTextController.text,
                            );
                            if (user == null) {
                              return;
                            }

                            context.goNamedAuth('Main', context.mounted);
                          },
                          child: Material(
                            color: Colors.transparent,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25.0),
                                bottomRight: Radius.circular(25.0),
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.6,
                              height: 40.0,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(
                                      0.0,
                                      2.0,
                                    ),
                                  )
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF3049FF),
                                    Color(0xFF5CE4FA)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: AlignmentDirectional(0.0, 1.0),
                                  end: AlignmentDirectional(0, -1.0),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25.0),
                                  bottomRight: Radius.circular(25.0),
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 0.0,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Create Account',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Combo',
                                    color: Colors.white,
                                    fontSize: 27.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 2.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Combo',
                                  color: Colors.black,
                                  fontSize: 24.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('LoginScreen');
                            },
                            child: Text(
                              'Log in',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                fontFamily: 'Combo',
                                color: Color(0xFF3019FF),
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 2.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ].divide(SizedBox(height: 29.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
