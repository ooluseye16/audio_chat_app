import 'package:audio_chat_app/helper_functions.dart';
import 'package:audio_chat_app/models/user.dart';
import 'package:audio_chat_app/provider/contact_provider.dart';
import 'package:audio_chat_app/repositories/auth_repository.dart';
import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:audio_chat_app/screen/chat_screen.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> contacts = [];

  @override
  void didChangeDependencies() {
    contacts = Provider.of<ContactsProvider>(context).contactsInDB;
    super.didChangeDependencies();
  }

  void createConversation(
      BuildContext context, String contactId,
      {String? displayName}) {
    final currentUser = FirebaseAuth.instance.currentUser;
    String convoID =
        HelperFunctions.getConversationID(currentUser!.uid, contactId);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChatScreen(
        conversationId: convoID,
        uid: currentUser.uid,
        contactId: contactId,
        displayName: displayName
      );
    }));
    //print(convoID);
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //     builder: (BuildContext context) => NewConversationScreen(
    //         uid: uid, contact: contact, convoID: convoID)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              AuthRepository(context).signOut();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          itemCount: contacts.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) => ListTile(
            onTap: () async {
              DatabaseRepository databaseRepository = DatabaseRepository();
              final UserDetails? user = await databaseRepository
                  .getUser(contacts[index].phones!.first.value!);
              if (user != null) {
                createConversation(context, user.id!, 
                    displayName: contacts[index].displayName);
              }
            },
            title: Text(contacts[index].displayName ?? "No name"),
            subtitle: Text(contacts[index].phones!.first.value!),
          ),
        ),
      ),
    );
  }
}
