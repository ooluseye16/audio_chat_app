import 'package:audio_chat_app/constants.dart';
import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateUsernameScreen extends StatelessWidget {
  UpdateUsernameScreen({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
  final DatabaseRepository databaseRepository = DatabaseRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Username'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                  databaseRepository.updateUserName(
                    nameController.text,
                  );
                  context.goNamed(homeRouteName);
                },
                child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
