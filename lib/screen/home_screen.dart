import 'package:audio_chat_app/repositories/auth_repository.dart';
import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  DatabaseRepository databaseRepository = DatabaseRepository();

  @override
  void initState() {
    super.initState();
    databaseRepository.getAllUsers();
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
                  databaseRepository.updateUserName(
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
