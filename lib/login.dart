import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor is inherited from theme
      body: Container(
        margin: const EdgeInsets.only(top: 116, left: 22, right: 22),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Welcome Back',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 124),
                TextField(
                  cursorColor: theme.colorScheme.primary,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  cursorColor: theme.colorScheme.primary,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/chat'),
                  child: Text('Login', style: theme.textTheme.labelLarge?.copyWith(color: Colors.white)),
                ),
                const SizedBox(height: 9),
                Text(
                  'Forgot Password?',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
