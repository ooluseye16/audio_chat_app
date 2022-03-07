import 'package:audio_chat_app/constants.dart';
import 'package:audio_chat_app/login_state.dart';
import 'package:audio_chat_app/models/user.dart';
import 'package:audio_chat_app/screen/error_page.dart';
import 'package:audio_chat_app/screen/home_screen.dart';
import 'package:audio_chat_app/screen/login_screen.dart';
import 'package:audio_chat_app/screen/otp_screen.dart';
import 'package:audio_chat_app/screen/splash_screen.dart';
import 'package:audio_chat_app/screen/update_username.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screen/chat_screen.dart';

class MyRouter {
  final LoginState loginState;
  MyRouter(this.loginState);

  late final router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    redirect: (state) {
      final isLoggedIn = loginState.loggedIn;
      final isLoggingIn = state.location == "/login";

      if (isLoggedIn && isLoggingIn) return "/home";
      return null;
    },
    routes: [
      GoRoute(
        name: rootRouteName,
        path: '/',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
          name: loginRouteName,
          path: '/login',
          pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: LoginScreen(),
              ),
          routes: [
            GoRoute(
              name: otpRouteName,
              path: "otp",
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: OTPScreen(verificationId: state.extra! as String),
              ),
            ),GoRoute(
              name: updatenameRouteName,
              path: "update_name",
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: UpdateUsernameScreen(),
              ),
            )
          ]),
      GoRoute(
        name: homeRouteName,
        path: '/home',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
        ),
        
        
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: ErrorPage(error: state.error),
    ),
  );
}
