import 'package:audio_chat_app/provider/contact_provider.dart';
import 'package:audio_chat_app/repositories/auth_repository.dart';
import 'package:contacts_service/contacts_service.dart';
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
  void initState() {
    super.initState();
    contacts =
        Provider.of<ContactsProvider>(context, listen: false).contactsInDB;
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
            title: Text(contacts[index].displayName ?? "No name"),
            subtitle: Text(contacts[index].phones!.first.value!),
          ),
        ),
      ),
    );
  }
}
