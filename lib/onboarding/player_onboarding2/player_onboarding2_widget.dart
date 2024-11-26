import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'player_onboarding2_model.dart';
export 'player_onboarding2_model.dart';

class PlayerOnboarding2Widget extends StatefulWidget {
  const PlayerOnboarding2Widget({super.key});

  @override
  State<PlayerOnboarding2Widget> createState() =>
      _PlayerOnboarding2WidgetState();
}

class _PlayerOnboarding2WidgetState extends State<PlayerOnboarding2Widget> {
  late PlayerOnboarding2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlayerOnboarding2Model());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();

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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Align(
          alignment: AlignmentDirectional(0.0, 1.0),
          child: Stack(
            alignment: AlignmentDirectional(0.0, 1.0),
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
              Opacity(
                opacity: 0.7,
                child: Align(
                  alignment: AlignmentDirectional(0.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 60.0),
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.88,
                      height: MediaQuery.sizeOf(context).height * 0.85,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
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
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Opacity(
                    opacity: 0.95,
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FlutterFlowIconButton(
                            buttonSize: 50.0,
                            icon: FaIcon(
                              FontAwesomeIcons.star,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                          FlutterFlowIconButton(
                            buttonSize: 50.0,
                            icon: Icon(
                              Icons.group,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.5, 0.0),
                            child: FlutterFlowIconButton(
                              buttonSize: 50.0,
                              icon: FaIcon(
                                FontAwesomeIcons.home,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 30.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ),
                          FlutterFlowIconButton(
                            buttonSize: 50.0,
                            icon: Icon(
                              Icons.sports_soccer,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                          FlutterFlowIconButton(
                            buttonSize: 50.0,
                            icon: Icon(
                              Icons.event,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 5.0)),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30.0,
                              buttonSize: 50.0,
                              icon: Icon(
                                Icons.local_post_office_outlined,
                                color: Colors.white,
                                size: 30.0,
                              ),
                              onPressed: () {
                                print('IconButton pressed ...');
                              },
                            ),
                          ],
                        ),
                        Align(
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            buttonSize: 50.0,
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 30.0,
                            ),
                            onPressed: () {
                              print('IconButton pressed ...');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(32.0, 32.0, 32.0, 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 0.0, 8.0),
                          child: Text(
                            'Enter you team name:',
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Combo',
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ),
                      Container(
                        width: 370.0,
                        child: TextFormField(
                          controller: _model.textController1,
                          focusNode: _model.textFieldFocusNode1,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Team Name',
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
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                  ),
                          validator: _model.textController1Validator
                              .asValidator(context),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 2.0, 0.0, 0.0),
                          child: Text(
                            'I cant find my team...',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Combo',
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(-1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              8.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Position on the field:',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context)
                                .displaySmall
                                .override(
                                  fontFamily: 'Combo',
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  lineHeight: 1.5,
                                ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue1 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue1 = newValue!);
                              },
                              side: BorderSide(
                                width: 2,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Text(
                              'Goalkeeper',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Combo',
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue2 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue2 = newValue!);
                              },
                              side: BorderSide(
                                width: 2,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Text(
                              'Defense',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Combo',
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue3 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue3 = newValue!);
                              },
                              side: BorderSide(
                                width: 2,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Text(
                              'Middlefield',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Combo',
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ),
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue4 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue4 = newValue!);
                              },
                              side: BorderSide(
                                width: 2,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context).info,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Text(
                              'Offense',
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    fontFamily: 'Combo',
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1.5,
                                  ),
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: Text(
                                'Height:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 370.0,
                              child: TextFormField(
                                controller: _model.textController2,
                                focusNode: _model.textFieldFocusNode2,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'In CM',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Combo',
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                  fillColor:
                                      FlutterFlowTheme.of(context).alternate,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Outfit',
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                                validator: _model.textController2Validator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: Text(
                                'Weight:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 370.0,
                              child: TextFormField(
                                controller: _model.textController3,
                                focusNode: _model.textFieldFocusNode3,
                                autofocus: true,
                                obscureText: false,
                                decoration: InputDecoration(
                                  labelText: 'In KG',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Combo',
                                        letterSpacing: 0.0,
                                      ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
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
                                  fillColor:
                                      FlutterFlowTheme.of(context).alternate,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Outfit',
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                    ),
                                validator: _model.textController3Validator
                                    .asValidator(context),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 5.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Your stronger leg:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                8.0, 0.0, 0.0, 0.0),
                            child: FlutterFlowRadioButton(
                              options: ['Right', 'Left'].toList(),
                              onChanged: (val) => safeSetState(() {}),
                              controller: _model.radioButtonValueController ??=
                                  FormFieldController<String>(null),
                              optionHeight: 32.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Combo',
                                    letterSpacing: 0.0,
                                  ),
                              buttonPosition: RadioButtonPosition.left,
                              direction: Axis.vertical,
                              radioButtonColor:
                                  FlutterFlowTheme.of(context).primary,
                              inactiveRadioButtonColor:
                                  FlutterFlowTheme.of(context).secondaryText,
                              toggleable: false,
                              horizontalAlignment: WrapAlignment.start,
                              verticalAlignment: WrapCrossAlignment.start,
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Speed:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Slider(
                              activeColor: FlutterFlowTheme.of(context).primary,
                              inactiveColor:
                                  FlutterFlowTheme.of(context).alternate,
                              min: 0.0,
                              max: 10.0,
                              value: _model.sliderValue1 ??= 0.0,
                              onChanged: (newValue) {
                                newValue =
                                    double.parse(newValue.toStringAsFixed(0));
                                safeSetState(
                                    () => _model.sliderValue1 = newValue);
                              },
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Headers:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Slider(
                              activeColor: FlutterFlowTheme.of(context).primary,
                              inactiveColor:
                                  FlutterFlowTheme.of(context).alternate,
                              min: 0.0,
                              max: 10.0,
                              value: _model.sliderValue2 ??= 0.0,
                              onChanged: (newValue) {
                                newValue =
                                    double.parse(newValue.toStringAsFixed(0));
                                safeSetState(
                                    () => _model.sliderValue2 = newValue);
                              },
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Defending:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Slider(
                              activeColor: FlutterFlowTheme.of(context).primary,
                              inactiveColor:
                                  FlutterFlowTheme.of(context).alternate,
                              min: 0.0,
                              max: 10.0,
                              value: _model.sliderValue3 ??= 0.0,
                              onChanged: (newValue) {
                                newValue =
                                    double.parse(newValue.toStringAsFixed(0));
                                safeSetState(
                                    () => _model.sliderValue3 = newValue);
                              },
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Passing:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Slider(
                              activeColor: FlutterFlowTheme.of(context).primary,
                              inactiveColor:
                                  FlutterFlowTheme.of(context).alternate,
                              min: 0.0,
                              max: 10.0,
                              value: _model.sliderValue4 ??= 0.0,
                              onChanged: (newValue) {
                                newValue =
                                    double.parse(newValue.toStringAsFixed(0));
                                safeSetState(
                                    () => _model.sliderValue4 = newValue);
                              },
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Scoring:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Slider(
                              activeColor: FlutterFlowTheme.of(context).primary,
                              inactiveColor:
                                  FlutterFlowTheme.of(context).alternate,
                              min: 0.0,
                              max: 10.0,
                              value: _model.sliderValue5 ??= 0.0,
                              onChanged: (newValue) {
                                newValue =
                                    double.parse(newValue.toStringAsFixed(0));
                                safeSetState(
                                    () => _model.sliderValue5 = newValue);
                              },
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 0.0, 0.0),
                              child: Text(
                                'Goalkeeping:',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .displaySmall
                                    .override(
                                      fontFamily: 'Combo',
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      lineHeight: 1.5,
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Slider(
                              activeColor: FlutterFlowTheme.of(context).primary,
                              inactiveColor:
                                  FlutterFlowTheme.of(context).alternate,
                              min: 0.0,
                              max: 10.0,
                              value: _model.sliderValue6 ??= 0.0,
                              onChanged: (newValue) {
                                newValue =
                                    double.parse(newValue.toStringAsFixed(0));
                                safeSetState(
                                    () => _model.sliderValue6 = newValue);
                              },
                            ),
                          ),
                        ].divide(SizedBox(width: 0.0)),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 40.0),
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
                                  'Continue',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                    fontFamily: 'Combo',
                                    color: Colors.white,
                                    fontSize: 24.0,
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
                    ].divide(SizedBox(height: 3.0)),
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
