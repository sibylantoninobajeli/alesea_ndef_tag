

import 'package:alesea_ndef_tag/local_data/database_helper.dart';
import 'package:alesea_ndef_tag/models/user.dart';

import '../globals.dart';
import 'internal_notidfication_providee.dart';

class AuthProvider {
  static DatabaseHelperSingleton db= DatabaseHelperSingleton();
  static bool _isLoggedIn=false;

  static Future<User> getUser(){
    return db.getUser();
  }

  static Future<int>  setUserLogin(user){
    return db.saveUser(user);
  }



  static void checkLogin() async{
    await db.existsUser().then((islogged) {
      _isLoggedIn=islogged;
      if (_isLoggedIn){
        db.getUser().then((_user){
          internalPushNotificationProvider
              .notifyNewInternalPush(
              InternalNotificationType
                  .LOGGED_IN,
              null);
        });
      }else{

        internalPushNotificationProvider
            .notifyNewInternalPush(
            InternalNotificationType
                .LOGGED_OUT,
            null);
      }
    });


  }

  static void doLogout() async{
    user=null;
    await db.deleteUsers();
    internalPushNotificationProvider
        .notifyNewInternalPush(
        InternalNotificationType
            .LOGGED_OUT,
        null);
  }

}