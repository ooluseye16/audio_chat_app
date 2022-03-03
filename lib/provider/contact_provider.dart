import 'dart:developer';

import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsProvider extends ChangeNotifier {
  ContactsProvider() {
    getContacts();
  }

  final DatabaseRepository _databaseRepository = DatabaseRepository();
  final List<Contact> contactsInDB = [];

  void getContacts() async {
    final phoneNumbers = await _databaseRepository.getAllUsersPhoneNumber();

    if (await Permission.contacts.request().isGranted) {
      List<Contact> contacts =
          await ContactsService.getContacts(withThumbnails: false);
      for (var phoneNumber in phoneNumbers) {
        log(phoneNumber);
        for (var contact in contacts) {
          if (contact.phones!.any((phone) => phone.value?.replaceAll(" ", "") == phoneNumber)) {
            log(contact.displayName!);
           
            contactsInDB.add(contact);
          }
        }
      }
      // print(contacts);
      // contactsInDB.addAll(contacts
      //     .where((element) =>
      //         phoneNumbers.contains(element.phones?.first.value))
      // .toList());
      // for (Contact contact in contactsInDB) {
      //   print(contact.phones?.first.value);
      // }
      notifyListeners();
    }
  }
}
