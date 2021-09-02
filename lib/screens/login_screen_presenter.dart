import 'dart:developer';
import '../globals.dart';
import 'package:alesea_ndef_tag/models/user.dart';
import 'package:alesea_ndef_tag/providers/auth_provider.dart';

abstract class LoginScreenContract {
  void onLoginSuccess();
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  LoginScreenPresenter(this._view);

  Future doLogin(String username, String password) async{

    if((isRelease)||(!skipLoginPhase)) {
      ///
      /// caso normale produzione
      ///
      user= User( password: password, username: username);
      if(username.compareTo(initialValueUsernameDemo1)==0){
        user!.roles.add(Roles.admin);
      }
      if(username.compareTo(initialValueUsernameDemo2)==0){
        user!.roles.add(Roles.viewer);
      }

      ///
      /// Configurazione impostata con USER e PWD
      ///

      /// CHIAMATA AD API LOGIN

          ///
          /// Conservo i dati di login nel DB Locale
          ///
          AuthProvider.setUserLogin(user).then((value) {
            log("doLogin"+ " savedFeedBack:"+value.toString());
            _view.onLoginSuccess();
          });

    }else{
      /// Fake user for DUMMY TESTS
      //User user=new User(0,"Fake","fakepwd","FakesLastname","FakesFirstname","FakeEmail",DateTime.now());

      user= User( password: password, username: username);
      if(username.compareTo(initialValueUsernameDemo1)==0){
        user!.roles.add(Roles.admin);
      }
      if(username.compareTo(initialValueUsernameDemo2)==0){
        user!.roles.add(Roles.viewer);
      }
      _view.onLoginSuccess();
    }
  }
}
