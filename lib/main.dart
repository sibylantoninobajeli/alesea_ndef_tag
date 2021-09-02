import 'package:alesea_ndef_tag/action..dart';
import 'package:alesea_ndef_tag/screens/intro/intro.dart';
import 'package:alesea_ndef_tag/screens/login_screen.dart';
import 'package:alesea_ndef_tag/screens/privacy_and_policy.dart';
import 'package:alesea_ndef_tag/screens/settings.dart';
import 'package:alesea_ndef_tag/styles_and_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'globals.dart';
import 'local_data/preferences_helper.dart';
import 'localization/custom_localizations.dart';
import 'models/user.dart';
import 'providers/internal_notidfication_providee.dart';

class CustomTheme {
  static ThemeData get lightTheme { //1
    return ThemeData( //2
        primaryColor: aleseaPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat', //3
        buttonTheme: ButtonThemeData( // 4
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.yellow,
        )
    );
  }
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

bool _firstAccess = true;



class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class  AppState  extends State<App> implements InternalNotificationListener {

  @override
  void initState() {
    // TODO: implement initState
    if ((!isRelease) && resetDeviceStoredPrefsUser) {
      /// forzo il logini se in modalità sviluppo
      ///  ed e' specificto
      clearPref();
    }
    internalPushNotificationProvider.subscribe(this);
    getCheckIsFirstAccess().then((isFirst) {
      setState(() {
        _firstAccess = isFirst;
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alesea',
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('it', 'IT'), // Italian
        // ... other locales the app supports
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        CustomLocalizationsDelegate(),
        const FallbackCupertinoLocalisationsDelegate(),

        GlobalMaterialLocalizations
            .delegate, // serve pr fare funzionare il form registration
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        //globals.localLog(runtimeType.toString()+"::"+_methodName, "localeResolutionCallback>Device locale  "+locale.languageCode+' '+locale.countryCode);
        languageCode = locale!.languageCode;

        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            //if (needDebug) globals.localLog(runtimeType.toString()+"::"+_methodName,  'returning '+supportedLocale.languageCode);
            return supportedLocale;
          }
        }
        //if (needDebug) globals.localLog(runtimeType.toString()+"::"+_methodName,  'returning '+supportedLocales.first.languageCode);
        return supportedLocales.first;
      },
        theme:CustomTheme.lightTheme,
        //home: MyApp(),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': ((BuildContext _context) => getProperRoot()),
        '/privacy': (BuildContext _context) => PrivacyAndPolicy(),
        '/intro': (BuildContext _context) => Intro(),
        //'/home': (BuildContext _context) => MyApp(),
        // Shown when launched with known deep link.

      },
    );
  }


  @override
  void dispose() {
    internalPushNotificationProvider.unsubscribe(this);
    super.dispose();
  }


  @override
  void onInternalNotification(InternalNotificationType type, Map<int, String>? mex) {
    switch (type) {
      case InternalNotificationType.FIRST_ACCESS_FALSE:
        setState(() {
          _firstAccess = false;
        });
        break;
      case InternalNotificationType.LOGGED_IN:
        setState(() {
          authState = InternalNotificationType.LOGGED_IN;
        });
        break;
      case InternalNotificationType.LOGGED_IN_AND_PRIVACY:
        setState(() {
          authState = InternalNotificationType.LOGGED_IN_AND_PRIVACY;
        });
        break;
      case InternalNotificationType.LOGGED_OUT:
        setState(() {
          authState = InternalNotificationType.LOGGED_OUT;
        });
        break;

      default:
    }
  }


}


Widget getProperRoot(){
  ///
    /// Check mode
    if (_firstAccess) {
      /// FIRST ACCESS
      return Intro();
    }else {
      /// standard Access
      if ((authState == InternalNotificationType.LOGGED_IN)||(authState == InternalNotificationType.LOGGED_IN_AND_PRIVACY)) {
        if (authState == InternalNotificationType.LOGGED_IN_AND_PRIVACY) {
          return AuthanticatedDashboard();
        }else{
          return PrivacyAndPolicy();
        }
      }else
          return LoginScreen();

    }
}


class AuthanticatedDashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AuthanticatedDashboardState();
}

class AuthanticatedDashboardState extends State<AuthanticatedDashboard> {
  bool isAdmin=false;
  @override
  Widget build(BuildContext context) {
    double _width=MediaQuery.of(context).size.width;
    double _height=MediaQuery.of(context).size.height;
    isAdmin = user!.roles.contains(Roles.admin);

    return Scaffold(

        appBar: AppBar(title: Text('Alesea TAG: '+user!.username),
        leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const Settings(),
                ),
              );
            }

    ),),
        body: SafeArea(
          child: Center(child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              getAssotiationButton(_width),
            getDeactivationButton(_width),
            getChangeSyncButton(_width)


            ],)),
        ),
    );
  }


  Widget getAssotiationButton(double _width){
    return
      ElevatedButton(
          onPressed: isAdmin?(){
        Navigator.push(context,
            MaterialPageRoute<void>(
                builder: (BuildContext context){
                  return Activation();
                }
            ));
      }:null,
          child: SizedBox(width:_width*0.8,child:Text("Association",style: TextStyle(fontSize: _width*0.06),)));
  }

  Widget getDeactivationButton(double _width){
    return
      ElevatedButton(onPressed: (){
        Navigator.push(context,
            MaterialPageRoute<void>(
                builder: (BuildContext context){
                  return Activation();
                }
            ));
      }, child: SizedBox(width:_width*0.8,child:Text("Deactivation",style: TextStyle(fontSize: _width*0.06),)));
  }

  Widget getChangeSyncButton(double _width){
    return
      ElevatedButton(onPressed: (){
        Navigator.push(context,
            MaterialPageRoute<void>(
                builder: (BuildContext context){
                  return Activation();
                }
            ));
      }, child: SizedBox(width:_width*0.8,child:Text("ChangeSync",style: TextStyle(fontSize: _width*0.06),)));
  }
}
