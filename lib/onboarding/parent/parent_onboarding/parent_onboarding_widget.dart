import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'parent_onboarding_model.dart';
export 'parent_onboarding_model.dart';

class ParentOnboardingWidget extends StatefulWidget {
  const ParentOnboardingWidget({super.key});

  @override
  State<ParentOnboardingWidget> createState() => _ParentOnboardingWidgetState();
}

class _ParentOnboardingWidgetState extends State<ParentOnboardingWidget> {
  late ParentOnboardingModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ParentOnboardingModel());

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
        body: SafeArea(
          top: true,
          child: Align(
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
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 130.0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.88,
                        height: MediaQuery.sizeOf(context).height * 0.7,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
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
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            'Welcome to FootballHero, [Parent Name]! Lets create and connect connect your profile to your child\'s Player card to access team news, stats, community updates, and all the perks FootballHero offers.',
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Container(
                            width: 370.0,
                            child: TextFormField(
                              controller: _model.textController1,
                              focusNode: _model.textFieldFocusNode1,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.textController1',
                                Duration(milliseconds: 2000),
                                () => safeSetState(() {}),
                              ),
                              autofocus: true,
                              textInputAction: TextInputAction.search,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Enter Child Username or Email',
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
                                fillColor:
                                    FlutterFlowTheme.of(context).alternate,
                                prefixIcon: Icon(
                                  Icons.search,
                                ),
                                suffixIcon: _model
                                        .textController1!.text.isNotEmpty
                                    ? InkWell(
                                        onTap: () async {
                                          _model.textController1?.clear();
                                          safeSetState(() {});
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          size: 22.0,
                                        ),
                                      )
                                    : null,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Outfit',
                                    fontSize: 16.0,
                                    letterSpacing: 0.0,
                                  ),
                              validator: _model.textController1Validator
                                  .asValidator(context),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 26.0, 0.0, 0.0),
                            child: Text(
                              'How are you two realted?',
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowRadioButton(
                              options: ['Mother'].toList(),
                              onChanged: (val) => safeSetState(() {}),
                              controller: _model.radioButtonValueController1 ??=
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
                            FlutterFlowRadioButton(
                              options: ['Father'].toList(),
                              onChanged: (val) => safeSetState(() {}),
                              controller: _model.radioButtonValueController2 ??=
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
                            FlutterFlowRadioButton(
                              options: [''].toList(),
                              onChanged: (val) => safeSetState(() {}),
                              controller: _model.radioButtonValueController3 ??=
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
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              height: 43.0,
                              decoration: BoxDecoration(),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                child: TextFormField(
                                  controller: _model.textController2,
                                  focusNode: _model.textFieldFocusNode2,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Other',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Combo',
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 26.0, 0.0, 0.0),
                            child: Text(
                              'Phone number:',
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FlutterFlowDropDown<String>(
                              controller: _model.dropDownValueController ??=
                                  FormFieldController<String>(null),
                              options: ['Country Code'],
                              onChanged: (val) => safeSetState(
                                  () => _model.dropDownValue = val),
                              width: 102.0,
                              height: 43.0,
                              textStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Combo',
                                    letterSpacing: 0.0,
                                    lineHeight: 1.0,
                                  ),
                              hintText: 'IL +972',
                              icon: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 20.0,
                              ),
                              fillColor: FlutterFlowTheme.of(context).alternate,
                              elevation: 2.0,
                              borderColor: FlutterFlowTheme.of(context).primary,
                              borderWidth: 2.0,
                              borderRadius: 8.0,
                              margin: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              hidesUnderline: true,
                              isOverButton: true,
                              isSearchable: false,
                              isMultiSelect: false,
                              labelText: 'Country Code',
                              labelTextStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'Combo',
                                    letterSpacing: 0.0,
                                    lineHeight: 1.0,
                                  ),
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.55,
                              height: 43.0,
                              decoration: BoxDecoration(),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                child: TextFormField(
                                  controller: _model.textController3,
                                  focusNode: _model.textFieldFocusNode3,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Number',
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          fontFamily: 'Combo',
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
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
                          ].divide(SizedBox(width: 10.0)),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
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
                      ].divide(SizedBox(height: 15.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
