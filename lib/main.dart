import 'package:flutter/material.dart';
import 'start_page.dart';
import 'login.dart';
import 'sign_up.dart';
import 'chat.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZeniFY',
      theme: ThemeData(
        primaryColor: const Color(0xFF5B95DC),
        fontFamily: 'Literata',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/chat': (context) => const ChatPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}