import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class LoginState extends ChangeNotifier {
  final SharedPreferences prefs;
  bool _loggedIn = false;

  LoginState(this.prefs) {
    _loggedIn = prefs.getBool(loggedInKey) ?? false;
  }

  bool get loggedIn => _loggedIn;
  void isloggedIn() {
    
  }


}