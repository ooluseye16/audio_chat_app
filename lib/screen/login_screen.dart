import 'dart:developer';
import 'package:audio_chat_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text('Register Screen'),
              const SizedBox(height: 50),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  log("aa");
                  final AuthRepository authRepository = AuthRepository(context);
                  await authRepository
                      .signUpWithPhoneNumber(phoneNumberController.text);
                },
                child: const Text('Register'),
              ),
             
              
            ],
          ),
        ),
      ),
    );
  }
}
