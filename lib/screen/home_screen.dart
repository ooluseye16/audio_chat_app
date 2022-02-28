import 'package:audio_chat_app/models/user.dart';
import 'package:audio_chat_app/repositories/auth_repository.dart';
import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              AuthRepository(context).signOut();
              
            },
          ),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  DatabaseRepository().updateUserName(
                   nameController.text,
                  );
                },
                child: const Text('Submit')),
          ],
        ),
      )),
    );
  }
}
