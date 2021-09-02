import 'dart:developer';
import 'package:alesea_ndef_tag/localization/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../styles_and_colors.dart';

/// // // //
/// Privacy and Policy page
/// // // //

class Privacy extends StatelessWidget {
  final String routeName = '/material/page-selector';

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

  static final formKey = GlobalKey<FormState>();
  final bool publicKeyPresent = false;


  Widget _getPrivacyPolicy(
      BuildContext context, double logoSize,String textContent) {
    return Padding(
        padding: EdgeInsets.only(top: logoSize / 3),
        child: Stack(alignment: Alignment.topCenter, children: <Widget>[
          SizedBox(height: logoSize, width: logoSize, child:
          Text(textContent),),

          Positioned(
            top: 2 * logoSize,
            child: ElevatedButton(
                onPressed: () async {

                },
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(logoSize * 0.4),

                  ),
                  padding: EdgeInsets.all(logoSize * 0.08),
                ).copyWith(
                    backgroundColor:
                        MaterialStateProperty.all(aleseaPrimaryColor)),
                child: Row(children: [Text('Grant access  ',style: TextStyle(fontSize: logoSize*0.08)),Icon(Icons.lock_open, size:logoSize*0.08*1.5)],)),
          ),
        ]));
  }
  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();
    log(status.toString());
  }


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    double logoSize = _height / 3;

    return Theme(
        data: ThemeData(
          primarySwatch: Colors.red, // e' un colore del material design
          brightness: Brightness.light,
          primaryColor: aleseaLogoColor,
        ),
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: null, // AppBar(title: const Text('Page selector')),
          body: _getPrivacyPolicy(context, logoSize,CustomLocalizations
              .of(context)!
              .privacYAndPolicy!),


        ));
  }
}
