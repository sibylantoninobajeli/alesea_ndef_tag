import 'dart:developer';

import 'package:alesea_ndef_tag/local_data/preferences_helper.dart';
import 'package:alesea_ndef_tag/localization/custom_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../assets.dart';
import '../../styles_and_colors.dart';
import 'page_selector.dart';

/// // // //
/// INTRO HANDLER
///
///
/// // // //

class Intro extends StatelessWidget {
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
                //style: Style(),
                textScaleFactor: 1.0,
                style: aleseaTextStyleRegularWhiteVeryBig),
            key: key),
      ),
    );
  }

  static void startAction(BuildContext context) {
    setCheckIsFirstAccessFalse();
  }

  static final formKey = GlobalKey<FormState>();

  final bool publicKeyPresent = false;

  final Widget _bkgImg1 = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
    image: imgAssetsLogo1,
    fit: BoxFit.fitHeight,
  )));

  final Widget _bkgImg2 = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
    image: imgAssetsLogo2,
    fit: BoxFit.cover,
  )));

  final Widget _bkgImg3 = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
    image: imgAssetsLogo3,
    fit: BoxFit.cover,
  )));

  final Widget _bkgHome = Container(
      decoration: BoxDecoration(
          image: DecorationImage(
    image: imgAssetsLogo3,
    fit: BoxFit.cover,
  )));

  Widget _getScreenContentInfo(
      BuildContext context, double logoSize, Widget bkgImg) {
    return Padding(
        padding: EdgeInsets.only(top: logoSize / 3),
        child: Stack(alignment: Alignment.topCenter, children: <Widget>[
          SizedBox(height: logoSize, width: logoSize, child: bkgImg),
          /*roundedTextContainer(Key('__testo_pres_1__'),
              CustomLocalizations.of(context)!.msg1!)*/
          Positioned(
              top: logoSize * 1,
              child: Text(
                CustomLocalizations.of(context)!.msg1!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: logoSize * 0.08, color: aleseaPrimaryColor),
              )),
          Positioned(
              top: 2 * logoSize,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(logoSize * 0.08),
                ).copyWith(
                    backgroundColor:
                        MaterialStateProperty.all(aleseaPrimaryColor)),
                child: imgAleseaArrowRigthAltWhite,
              ))
        ]));
  }

  Widget _getScreenContentPermissions(
      BuildContext context, double logoSize, Widget bkgImg) {
    return Padding(
        padding: EdgeInsets.only(top: logoSize / 3),
        child: Stack(alignment: Alignment.topCenter, children: <Widget>[
          SizedBox(height: logoSize, width: logoSize, child: bkgImg),
          /*roundedTextContainer(Key('__testo_pres_1__'),
              CustomLocalizations.of(context)!.msg1!)*/
          /*Positioned(
              top: logoSize * 1,
              child: Text(
                CustomLocalizations.of(context)!.msg1!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: logoSize * 0.08, color: aleseaPrimaryColor),
              )),*/
          Positioned(
            top: 2 * logoSize,
            child: ElevatedButton(
                onPressed: () async {


                  var statusCam = await Permission.camera.status;
                  if (await Permission.camera.isPermanentlyDenied) {
                    // The user opted to never again see the permission request dialog for this
                    // app. The only way to change the permission's status now is to let the
                    // user manually enable it in the system settings.
                    openAppSettings();
                  }
                  if (statusCam.isDenied) {
                    log("permission statusCam denied");
                    await requestPermission(Permission.camera);
                  }


                  if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
                    log("permission locationWhenInUse enabled");
                    await requestPermission(Permission.locationWhenInUse);
                  }else{
                    log("permission locationWhenInUse disabled");
                  }


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


  Widget _getScreenContentLogin(
      BuildContext context, double logoSize, Widget bkgImg) {
    return Padding(
        padding: EdgeInsets.only(top: logoSize / 3),
        child: Stack(alignment: Alignment.topCenter, children: <Widget>[
          SizedBox(height: logoSize, width: logoSize, child: bkgImg),

          Positioned(
            top: 2 * logoSize,
            child: ElevatedButton(
                onPressed: () async {
                  startAction(context);
                },
                style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(logoSize * 0.4),

                  ),
                  padding: EdgeInsets.all(logoSize * 0.08),
                ).copyWith(
                    backgroundColor:
                    MaterialStateProperty.all(aleseaPrimaryColor)),
                child: Row(children: [Text('Login ',style: TextStyle(fontSize: logoSize*0.08)),Icon(Icons.lock_open, size:logoSize*0.08*1.5)],)),
          ),
        ]));
  }
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    double logoSize = _height / 3;
    final List<Widget> widgetPages = <Widget>[
      _getScreenContentInfo(context, logoSize, _bkgImg1),
      _getScreenContentPermissions(context, logoSize, _bkgImg2),
      _getScreenContentLogin(context, logoSize, _bkgImg3),
      /*Stack(children: <Widget>[
        _bkgImg2,
        roundedTextContainer(
            Key('__testo_pres_2__'), CustomLocalizations.of(context)!.title!)
      ]),
      Stack(children: <Widget>[
        _bkgImg3,
        roundedTextContainer(
            Key('__testo_pres_3__'), CustomLocalizations.of(context)!.title!)
      ]),
      Scaffold(
          appBar: null,
          body: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                _bkgHome,
                Container(
                  //color:Colors.blue,
                  padding: const EdgeInsets.only(top: 0.0),
                  child: ClipRect(
                    child: Container(
                      //color:Colors.redAccent,
                      padding: const EdgeInsets.only(top: 75.0, bottom: 10.0),
                      child: imgAleseaTopTitle,
                      height: 150.0,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 450.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              key: Key('__chooseform_loginbtn__'),
                              onTap: () => startAction(context),
                              child: Container(
                                width: 200.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 2.0),
                                  borderRadius: BorderRadius.circular(26 / 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                      CustomLocalizations.of(context)!.title!,
                                      style:
                                          aleseaTextStyleRegularWhiteVeryBig),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ])),
    */

    ];

    return Theme(
        data: ThemeData(
          primarySwatch: Colors.red, // e' un colore del material design
          brightness: Brightness.light,

          /// canvans di base chiara
          ///
          primaryColor: aleseaLogoColor,
        ),
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: null, // AppBar(title: const Text('Page selector')),
          body: DefaultTabController(
            length: widgetPages.length,
            child: PageSelectorStfl(widgetPages: widgetPages),
          ),
        ));
  }
}
