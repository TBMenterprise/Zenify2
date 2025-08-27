
import 'package:flutter/material.dart';
import '../SubPages/go_premium.dart';
import '../SubPages/change_username.dart';
import '../SubPages/delete_account.dart';
import '../SubPages/update_password.dart';
import 'chat.dart';
import 'login.dart';
import 'settings.dart';
import 'sign_up.dart';
import 'start_page.dart';
import '../SubPages/reset_password.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zenify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/start_page',
      routes: {
        '/auth_layout': (context) => const StartPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/chat': (context) => const ChatPage(),
        '/settings': (context) => const SettingsPage(),
        '/reset_password': (context) => const ResetPasswordPage(),
        '/start_page': (context) => const StartPage(),
        '/user_profile_setup': (context) => const StartPage(),
        '/go_premium': (context) => const GoPremiumPage(),
        '/change_username': (context) => const ChangeUsernamePage(),
        '/delete_account': (context) => const DeleteAccountPage(),
        '/update_password': (context) => const UpdatePasswordPage(),
      },
    );
  }
}
