import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginState extends ChangeNotifier {
  //final SharedPreferences prefs;
  bool _loggedIn = false;

 

  bool get loggedIn => _loggedIn;
  void isloggedIn() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        _loggedIn = false;
        //prefs.setBool(loggedInKey, false);
      } else {
        _loggedIn = true;
       // prefs.setBool(loggedInKey, false);
      }
    });
    notifyListeners();
  }
}
