import 'package:audio_chat_app/constants.dart';
import 'package:audio_chat_app/models/user.dart';
import 'package:audio_chat_app/repositories/database_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthRepository {
  final BuildContext context;
  AuthRepository(this.context);
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signUpWithPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!

        // Sign the user in (or link) with the auto-generated credential
        //await auth.signInWithCredential(credential);
        // context.goNamed(homeRouteName);
      },
      verificationFailed: (FirebaseAuthException error) {
        if (error.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        context.goNamed(otpRouteName, extra: verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      if (authCredential.user != null) {
        DatabaseRepository().saveUser(UserDetails(
          phoneNumber: authCredential.user!.phoneNumber,
          id: authCredential.user!.uid,
        ));
        context.goNamed(homeRouteName);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);
    }
  }

  void signOut() {
    auth.signOut();
    context.goNamed(loginRouteName);
  }
}
