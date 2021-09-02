library alesea_ndef_tag.globals;
import 'package:alesea_ndef_tag/providers/internal_notidfication_providee.dart';

import 'models/user.dart';

const bool isRelease = bool.fromEnvironment("dart.vm.product");

///*******************************************************************************
///* DEBUG ONLY SETTINGS
///* */
const bool resetDeviceStoredPrefsUser = true; //

/// jump to login page avoiding the intro
const bool skipIntroPhase = false;

/// used for developing in OFFLINE MODE
const bool skipLoginPhase = false;

/// let application open using FAKE user object
const bool useFakePosition = true;

String? languageCode;
String initialValueUsernameDemo1 = "demouserAdmin";
String initialValueUsernameDemo2 = "demoReader";
String initialValuePassword = "demoPwd";
String adminEmail = initialValueUsernameDemo1;


User? user = User( username: initialValueUsernameDemo1, password:initialValuePassword);
InternalNotificationType authState = InternalNotificationType.LOGGED_OUT;

//const String testEndPoint = "http://192.168.10.25:8000"; //for DEBUG mode
const String prodEndPoint = "https://alesea.com"; //for RELEASE
