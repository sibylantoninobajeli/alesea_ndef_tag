import 'package:alesea_ndef_tag/localization/custom_localizations.dart';
import 'package:alesea_ndef_tag/models/user.dart';
import 'package:alesea_ndef_tag/providers/internal_notidfication_providee.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import '../../styles_and_colors.dart';
import '../globals.dart';

/// // // //
/// Settings page
/// // // //

/// This is the stateful widget that the main application instantiates.
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SettingsState extends State<Settings> {
  static final formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double textAreaSize = _width * 0.9;

    return Theme(
        data: ThemeData(

          brightness: Brightness.light,
          primaryColor: backgroundColor,
        ),
        child: Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              title: const Text('Settings'),
              centerTitle: true,
              elevation: 0,
            ),
            body: _getSettings(context)));
  }

  Widget _getSettings(BuildContext contex) {
    double width = MediaQuery.of(context).size.width;

    double titleCharSize = width * 0.06;
    double iconSize = width * 0.1;
    double bodyCharSize = titleCharSize * 0.7;
    double acceptCharSize = titleCharSize * 0.8;

    return Padding(
        padding: EdgeInsets.only(top: width / 5),
        child: Align(
            alignment: Alignment.topCenter,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ///

                  Padding(
                      padding: EdgeInsets.all(iconSize / 3),
                      child: getLoggedInfo(user!, iconSize)),

                  Divider(
                    color: Colors.transparent,
                  ),

                  Spacer(),
                  getCheckPolicy( iconSize / 3, CustomLocalizations.of(context)!.privacyAndPolicyAccept!,),
                  Spacer(),
                  getVersion()
                ])));
  }

  Widget getLoggedInfo(User user, double iconSize) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: disabledColor,
                border: Border.all(
                  color: disabledColor,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: (Column(
              children: [
                /// USER INFO
                Padding(
                    padding: EdgeInsets.all(iconSize / 3),
                    child: ListTile(
                      leading: Icon(
                        Icons.perm_contact_cal_outlined,
                        color: aleseaPrimaryColor,
                        size: iconSize,
                      ),
                      title: Text(
                        "You are logged as:",
                        style: TextStyle(color: textColor),
                      ),
                      subtitle: Text(user.username,
                          style: TextStyle(
                              color: textColor,
                              fontSize: iconSize * 0.7,
                              fontWeight: FontWeight.bold)),
                    )),

                /// LOGOUT BUTTON
                Padding(
                  padding: EdgeInsets.all(iconSize / 3),
                  child: getLogoutButton(context, iconSize * 2),
                )
              ],
            ))),
      ],
    );
  }

  Widget getLogoutButton(BuildContext context, double heigth) {
    return SizedBox(
        width: heigth * 2.5,
        height: heigth,
        child: ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              internalPushNotificationProvider.notifyNewInternalPush(
                  InternalNotificationType.LOGGED_OUT, null);

            },
            style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(heigth * 0.5),
              ),
              padding: EdgeInsets.all(heigth * 0.08),
            ).copyWith(
                backgroundColor: MaterialStateProperty.all(aleseaPrimaryColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(CustomLocalizations.of(context)!.logout!+'   ', style: TextStyle(fontSize: heigth * 0.3)),
                Icon(Icons.logout, size: heigth * 0.5)
              ],
            )));
  }



  Widget getCheckPolicy(double textAreaSize,String textAccept){
    double acceptCharSize= textAreaSize;
    bool isChecked=(authState == InternalNotificationType.LOGGED_IN_AND_PRIVACY);

    return Row(
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
    );
  }


  Widget getGPSPermission(double textAreaSize,String textAccept){
    double acceptCharSize= textAreaSize;
    bool isChecked=(authState == InternalNotificationType.LOGGED_IN_AND_PRIVACY);

    return Row(
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
    );
  }

  Widget getVersion() {
    return Center(
      child: Text("Version 1.0.1 (4)"),
    );
  }
}
