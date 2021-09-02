import 'dart:developer';
import 'package:alesea_ndef_tag/localization/custom_localizations.dart';
import 'package:alesea_ndef_tag/providers/internal_notidfication_providee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../styles_and_colors.dart';

/// // // //
/// Privacy and Policy page
/// // // //

/// This is the stateful widget that the main application instantiates.
class PrivacyAndPolicy extends StatefulWidget {
  const PrivacyAndPolicy({Key? key}) : super(key: key);

  @override
  State<PrivacyAndPolicy> createState() => _PrivacyAndPolicyState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _PrivacyAndPolicyState extends State<PrivacyAndPolicy> {
  static final formKey = GlobalKey<FormState>();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double textAreaSize = _width * 0.9;

    return Theme(
        data: ThemeData(
          brightness: Brightness.light,
          primaryColor: aleseaLogoColor,
        ),
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: null, // AppBar(title: const Text('Page selector')),
            body: _getPrivacyPolicy(
                context,
                textAreaSize,
                CustomLocalizations.of(context)!.privacyAndPolicyTitle!,
                CustomLocalizations.of(context)!.privacyAndPolicyBody!,
                CustomLocalizations.of(context)!.privacyAndPolicyAccept!)));
  }

  Widget _getPrivacyPolicy(BuildContext context, double textAreaSize,
      String title, String textContent, String textAccept) {
    double titleCharSize = textAreaSize * 0.06;
    double bodyCharSize = titleCharSize * 0.7;
    double acceptCharSize = titleCharSize * 0.8;

    return Padding(
        padding: EdgeInsets.only(top: textAreaSize / 5),
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///
                  ///
                  ///
                  /// TITOLO
                  SizedBox(
                    height: titleCharSize * 1.2,
                    width: textAreaSize,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: titleCharSize, fontWeight: FontWeight.bold),
                    ),
                  ),

                  Divider(
                    height: textAreaSize * 0.2,
                    color: Colors.transparent,
                  ),

                  ///
                  ///
                  ///
                  /// CORPO TESTO
                  SizedBox(
                      height: textAreaSize * 1,
                      width: textAreaSize,
                      child: SingleChildScrollView(
                        child: Text(
                          textContent,
                          textAlign: TextAlign.left,
                          //maxLines: 20,
                          style: TextStyle(fontSize: bodyCharSize,
                          color: aleseaSecondaryColor
                          ),
                        ),
                      )),

                  Spacer(),

                  ///
                  ///
                  /// CHECKBOX
                  ///
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left: textAreaSize * 0.05),
                          child: Transform.scale(
                              scale: 2,
                              child: Checkbox(
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.resolveWith(
                                    getCheckboxColor),
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(4),
                                ),
                              ))),
                      Padding(
                          padding: EdgeInsets.only(left: textAreaSize * 0.02),
                          child: Text(
                            textAccept,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: acceptCharSize),
                          )),
                    ],
                  ),
                  Spacer(),

                  ///
                  ///
                  ///
                  /// PULSANTONE
                  SizedBox(
                    height: 80,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: isChecked
                            ? () async {
                                internalPushNotificationProvider
                                    .notifyNewInternalPush(
                                        InternalNotificationType
                                            .LOGGED_IN_AND_PRIVACY,
                                        null);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius:
                                new BorderRadius.circular(textAreaSize * 0.4),
                          ),
                          padding: EdgeInsets.all(textAreaSize * 0.08),
                        ).copyWith(
                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.5);
                                else if (states.contains(MaterialState.disabled))
                                  return Colors.white;
                                return Colors.white; // Use the component's default.
                              },
                            ),
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5);
                            else if (states.contains(MaterialState.disabled))
                              return disabledColor;
                            return aleseaPrimaryColor; // Use the component's default.
                          },
                        )),
                        child: Text('Continue',
                            style: TextStyle(fontSize: titleCharSize * 1))),
                  ),

                  Spacer(),
                ])));
  }



  Widget roundedTextContainer(Key key, String text) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 170.0, left: 20.0, right: 20.0),
        child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: new BoxDecoration(
              color: const Color(0x88999999),
              borderRadius: new BorderRadius.all(
                const Radius.circular(40.0),
              ),
            ),
            child: Text(text,
                textAlign: TextAlign.center,
                textScaleFactor: 1.0,
                style: aleseaTextStyleRegularWhiteVeryBig),
            key: key),
      ),
    );
  }
}
