import 'package:flutter/material.dart';
import '../SubPages/apploading.dart';
import 'auth_services.dart';
import '../MainPages/chat.dart';
import '../MainPages/start_page.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.value.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoadingPage();
        } else if (snapshot.hasData) {
          return ChatPage();
        } else {
          return const StartPage();
        }
      },
    );
  }
}