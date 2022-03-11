import 'dart:developer';

import 'package:audio_chat_app/extensions.dart';
import 'package:audio_chat_app/models/messages.dart';
import 'package:audio_chat_app/models/user.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseRepository {
  static final DatabaseRepository _databaseRepository =
      DatabaseRepository._internal();

  factory DatabaseRepository() {
    return _databaseRepository;
  }
 
  DatabaseRepository._internal() {
    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);

    _messagesRef = database.ref('users');
  }


 final currentUser = FirebaseAuth.instance.currentUser;
  late DatabaseReference _messagesRef;
  
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

  Query getMessageQuery() {
    return _messagesRef;
  }

  Future<List<UserDetails>> getAllUsers() async {
    List<UserDetails> users = [];
    await _messagesRef.once().then((data) {
      var values = data.snapshot.value as Map<dynamic, dynamic>;
      values.forEach((key, value) {
        users.add(UserDetails.fromJson(value));
      });
    });
    return users;
  }

  Future<List<String>> getAllUsersPhoneNumber() async {
    List<UserDetails> users = await getAllUsers();
    List<String> phoneNumbers = [];
    for (var user in users) {
      if (user.phoneNumber != null) {
        phoneNumbers.add(user.phoneNumber!);
      }
    }
    return phoneNumbers
        .where((element) => element != currentUser?.phoneNumber)
        .toList();
  }

  Future<UserDetails?> getUser(String phoneNumber) async {
    List<UserDetails?> users = await getAllUsers();

    final UserDetails? user = users.firstWhereOrNull((element) =>
        element?.phoneNumber?.validPhoneNumber ==
        phoneNumber.replaceAll(" ", "").validPhoneNumber);

    if (user != null) {
      print(user.toString());
      return user;
    } else {
      print('user not found');
      return null;
    }
  }

  static void sendMessage(Message message, String convId) {
    final DatabaseReference messagesRef = FirebaseDatabase.instance
        .ref('messages')
        .child(convId)
        .child(message.timeStamp);

    messagesRef.set(message.toJson());
  }
}
