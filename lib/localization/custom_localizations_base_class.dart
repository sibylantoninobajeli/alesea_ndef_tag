import 'custom_localizations_static_map.dart' as static_loc;
import 'package:flutter/material.dart';

class CustomLocalizationsBaseClass {
CustomLocalizationsBaseClass(this.locale);
final Locale locale;
  String? get title {return static_loc.localizedValues[locale.languageCode]!['title']; }
  String? get msg1 {return static_loc.localizedValues[locale.languageCode]!['msg1']; }
  String? get loginPageMex {return static_loc.localizedValues[locale.languageCode]!['loginPageMex']; }
  String? get usernameLabel {return static_loc.localizedValues[locale.languageCode]!['usernameLabel']; }
  String? get passwordLabel {return static_loc.localizedValues[locale.languageCode]!['passwordLabel']; }
  String? get mostraPasswordMex {return static_loc.localizedValues[locale.languageCode]!['mostraPasswordMex']; }
  String? get nascondiPasswordMex {return static_loc.localizedValues[locale.languageCode]!['nascondiPasswordMex']; }
  String? get logout {return static_loc.localizedValues[locale.languageCode]!['logout']; }

  String? get chooserDemo1LoginMex {return static_loc.localizedValues[locale.languageCode]!['chooserDemo1LoginMex']; }
  String? get chooserDemo2LoginMex {return static_loc.localizedValues[locale.languageCode]!['chooserDemo2LoginMex']; }
  String? get privacyAndPolicyTitle {return static_loc.localizedValues[locale.languageCode]!['privacyAndPolicyTitle']; }
  String? get privacyAndPolicyBody {return static_loc.localizedValues[locale.languageCode]!['privacyAndPolicyBody']; }
String? get privacyAndPolicyAccept {return static_loc.localizedValues[locale.languageCode]!['privacyAndPolicyAccept']; }

}