import 'dart:ui';
import 'package:alesea_ndef_tag/localization/custom_localizations.dart';
import 'package:alesea_ndef_tag/providers/auth_provider.dart';
import 'package:alesea_ndef_tag/providers/internal_notidfication_providee.dart';
import 'package:alesea_ndef_tag/styles_and_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../assets.dart';
import '../globals.dart';
import 'login_screen_presenter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String? _password, _username;
  LoginScreenPresenter? _presenter;
  bool _isObscured = true;
  TextEditingController pwdCtrl = TextEditingController();
  TextEditingController usrCtrl = TextEditingController();

  get minLoginCharNum => 6;


  @override
  initState() {
    super.initState();
    debugPrint(" LoginScreenNewState");

    ///
    /// Check for user logged in
    /// In case logged
    AuthProvider.checkLogin();

    //pwdCtrl.text = globals.initialValuePassword;
    pwdCtrl.addListener(() {
      setState(() {});
    });
  }

  LoginScreenState() {
    _presenter = LoginScreenPresenter(this);
  }

  /*
  void showDemoDialog<T>({BuildContext context, Widget child}) {
    showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
      print("$value");
    });
  }*/

  void onLoginError(String errorTxt) {
    _isLoading = false;
    if (mounted) setState(() {});

  }

  void onLoginSuccess() async {
    setState(() => _isLoading = false);
    internalPushNotificationProvider
        .notifyNewInternalPush(InternalNotificationType.LOGGED_IN, null);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form!.validate()) {
      setState(() => _isLoading = true);
      form.save();
      usrCtrl.text="";
      pwdCtrl.text="";
      _presenter!.doLogin(_username!, _password!);
    }
  }

  void _commuteObscurePws() {
    setState(() {
      _isObscured = _isObscured ? false : true;
      print(_isObscured);
    });
  }

  static void openChangePwd(BuildContext context) {
    /*
    print("Cliccked openChangePwd");

    Navigator.of(context).push(
      CupertinoPageRoute<void>(
          title: "Reimposta password",
          builder: (BuildContext context) => ChangePwdScreen()),
    );*/
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      /*navigationBar: CupertinoNavigationBar(
        middle: imgAssetsMicroLogin,
      ),*/
      child: SafeArea(
          top: false,
          bottom: true,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 0.0,

                      child: Column(
                        children: <Widget>[
                          //Expanded(child: Container()),

                          Expanded(
                              child: Form(
                                key: formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Spacer(),
                                    Spacer(),
                                    SizedBox(width:150,height: 150,child:imgAssetsMicroLogin),
                                    Text(
                                      CustomLocalizations.of(context)!.loginPageMex!,
                                      textScaleFactor: 2.0,
                                      style: aleseaTextStyleRegularWhite,
                                      textAlign: TextAlign.left,
                                    ),
                                    TextFormField(
                                      style: aleseaTextStyleRegularWhite,
                                      onSaved: (val) => _username = val,
                                      //initialValue: globals.initialValueUsername,
                                      controller: usrCtrl,
                                      /*validator: (val) {
                                        return val.length < minLoginCharNum
                                            ? CustomLocalizations.of(context)!
                                            .messaggioMinUsernameLengthMex(
                                            minLoginCharNum)
                                            : null;
                                      },*/
                                      decoration: InputDecoration(
                                          labelText: CustomLocalizations.of(context)!
                                              .usernameLabel),
                                    ),
                                    TextFormField(
                                      style: aleseaTextStyleRegularWhite,
                                      obscureText: _isObscured,
                                      onSaved: (val) => _password = val,
                                      //initialValue: globals.initialValuePassword,
                                      controller: pwdCtrl,
                                      decoration: InputDecoration(
                                          labelText: CustomLocalizations.of(context)!
                                              .passwordLabel),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        key: Key('__loginform_showpwd__'),
                                        onTap: () => _commuteObscurePws(),
                                        child: Text(
                                            _isObscured
                                                ? CustomLocalizations.of(context)!
                                                .mostraPasswordMex!
                                                : CustomLocalizations.of(context)!
                                                .nascondiPasswordMex!,
                                            textAlign: TextAlign.left,
                                            style:
                                            aleseaTextStyleRegularWhite),
                                      ),
                                    ),
                                   /*
                                    Container(

                                        child: Row(
                                          children: <Widget>[
                                            InkWell(
                                              key: Key('__loginform_changepwd__'),
                                              onTap: () {
                                                openChangePwd(context);
                                              },
                                              child: Text(
                                                  CustomLocalizations.of(context)
                                                      .loginLostPasswordMex,
                                                  style: aleseaTextStyleRegularWhite),
                                            ),


                                            Expanded(child: Container()),
                                            _isLoading
                                                ? CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<
                                                    Color>( aleseaLogoColor))
                                                : Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: (pwdCtrl.text.length < 2)
                                                  ? Container()
                                                  : InkWell(
                                                key: Key(
                                                    '__loginform_loginbtn__'),
                                                onTap: () {
                                                  if (pwdCtrl.text.length >
                                                      0) _submit();
                                                },
                                                child: Container(
                                                  width: 80.0,
                                                  height: 30.0,
                                                  decoration: BoxDecoration(
                                                    color: aleseaLogoColor,
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2.0),
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        26 / 1.5),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        CustomLocalizations
                                                            .of(context)!
                                                            .chooserLoginMex,
                                                        style: aleseaTextStyleRegularWhite),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    */
                                    Spacer(),

                                    _isLoading
                                        ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                            Color>(
                                            aleseaPrimaryColor))
                                        : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        key: Key(
                                            '__loginform_logindemo1btn__'),
                                        onTap: () {
                                          usrCtrl.text=initialValueUsernameDemo1;
                                          pwdCtrl.text=initialValuePassword;
                                          _submit();
                                        },
                                        child: Container(
                                          width: 180.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            color: aleseaPrimaryColor,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                26 / 1.5),
                                          ),
                                          child: Center(
                                            child: Text(
                                                CustomLocalizations
                                                    .of(context)!
                                                    .chooserDemo1LoginMex!,
                                                style:  aleseaTextStyleRegularWhite),
                                          ),
                                        ),
                                      ),
                                    ),


                                    _isLoading
                                        ? CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<
                                            Color>(
                                            aleseaPrimaryColor))
                                        : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        key: Key(
                                            '__loginform_logindem2obtn__'),
                                        onTap: () {
                                          usrCtrl.text=initialValueUsernameDemo2;
                                          pwdCtrl.text=initialValuePassword;
                                          _submit();
                                        },
                                        child: Container(
                                          width: 180.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            color: aleseaPrimaryColor,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2.0),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                26 / 1.5),
                                          ),
                                          child: Center(
                                            child: Text(
                                                CustomLocalizations
                                                    .of(context)!
                                                    .chooserDemo2LoginMex!,
                                                style:  aleseaTextStyleRegularWhite),
                                          ),
                                        ),
                                      ),
                                    ),


                                    Spacer()
                                  ],
                                ),
                              )),

                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }
}
