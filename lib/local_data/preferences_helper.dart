library alesea_ndef_tag.globals;
import 'dart:developer';
import 'package:alesea_ndef_tag/providers/internal_notidfication_providee.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefs = SharedPreferences.getInstance();

Future<bool> clearPref() async {
  return (await prefs).clear().then((resSucc) {
    if (resSucc) {
      log(" clearPref!");
      return true;
    }
    return false;
  });
}


Future<bool> getCheckIsFirstAccess() async {
  // obtain shared preferences
  try {
    bool? isFirstAccess = (await prefs).getBool('first_access');
    isFirstAccess = isFirstAccess != null ? isFirstAccess : true;
    log("loaded" +" isFirstAccess :" + isFirstAccess.toString());
    return isFirstAccess;
  } catch (e) {
    return true;
  }
}

setJsonStrUser(jsonStrUser) async {
  try {
    (await prefs).setString('user', jsonStrUser);
    log("setJsonStrUser"+ " user :" + jsonStrUser);
    return jsonStrUser;
  } catch (e) {
    return null;
  }
}

Future<String?> getJsonStrUser() async {
  try {
    String? jsonStrUser = (await prefs).getString('user');
    log("getUserJSON"+" user :" + jsonStrUser.toString());
    return jsonStrUser;
  } catch (e) {
    return null;
  }
}

setCheckIsFirstAccessFalse() async {
  // obtain shared preferences
  try {
    (await prefs).setBool('first_access', false);
    log("loaded"+ " isFirstAccess :FALSE");
    internalPushNotificationProvider.notifyNewInternalPush(
        InternalNotificationType.FIRST_ACCESS_FALSE, null);
  } catch (e) {}
}