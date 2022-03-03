import 'package:flutter/material.dart';

class UpdateUsername extends StatelessWidget {
  UpdateUsername({Key? key}) : super(key: key);

  final TextEditingController nameController = TextEditingController();
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
                  // databaseRepository.updateUserName(
                  //   nameController.text,
                  // );
                },
                child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
