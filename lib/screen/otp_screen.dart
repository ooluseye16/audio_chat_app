import 'package:audio_chat_app/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  final String verificationId;
  final TextEditingController otpController = TextEditingController();

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
              const Text('OTP Screen'),
              const SizedBox(height: 50),
              TextFormField(
                controller: otpController,
                decoration: const InputDecoration(
                  labelText: 'OTP',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  PhoneAuthCredential phoneAuthCredential =
                      PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: otpController.text);

                  final AuthRepository authRepository = AuthRepository(context);
                  authRepository
                      .signInWithPhoneAuthCredential(phoneAuthCredential);
                },
                child: const Text("Confirm OTP"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
