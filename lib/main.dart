import 'package:flutter/material.dart';
import 'package:mainproject/chat.dart';
import 'package:mainproject/login.dart';
import 'start_page.dart';
import 'package:mainproject/sign_up.dart';
import 'package:mainproject/settings.dart';

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
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B95DC),
          surface: const Color(0xffF1F5FA),
          primary: const Color(0xFF5B95DC)
        ),
        fontFamily: 'Literata',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Literata',
            fontSize: 50.52,
            color: Colors.white,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Literata',
            fontSize: 28.43,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Literata',
            fontSize: 16,
            color: Colors.black87,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Literata',
            fontSize: 21.33,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5B95DC),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0x24767676),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          hintStyle: const TextStyle(
            fontFamily: 'Literata',
            fontSize: 16,
            color: Color(0xFF767676),
          ),
        ),
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