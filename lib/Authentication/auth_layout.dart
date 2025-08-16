import 'package:flutter/material.dart';
import '../SubPages/apploading.dart';
import 'auth_services.dart';
import '../MainPages/chat.dart';
import '../MainPages/start_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_profile_setup.dart';

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
          final user = snapshot.data;
          if (user == null) {
            return const StartPage();
          }
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, userSnap) {
              if (userSnap.connectionState == ConnectionState.waiting) {
                return const AppLoadingPage();
              }
              if (!userSnap.hasData || !userSnap.data!.exists) {
                // No profile, go to setup
                return const UserProfileSetupPage();
              }
              return ChatPage();
            },
          );
        } else {
          return const StartPage();
        }
      },
    );
  }
}