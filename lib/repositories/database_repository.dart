import 'dart:developer';

import 'package:audio_chat_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseRepository {
  final currentUser = FirebaseAuth.instance.currentUser;
  final DatabaseReference _messagesRef =
      FirebaseDatabase.instance.ref().child('users');

  saveUser(UserDetails user) {
    _messagesRef.child(currentUser!.uid).update(user.toJson());
  }

  updateUserName(String name) {
    try {
      _messagesRef.child(currentUser!.uid).update({'name': name});
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }
}
