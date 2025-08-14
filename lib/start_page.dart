import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  // This widget is the root of your application.
  // ...existing code...
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: const Color(0xFF8CB2E1),
        body: Container(
          margin: const EdgeInsets.only(bottom: 60, left: 26, right: 26),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'ZeniFY',
                  style: theme.textTheme.displayLarge,
                ),
                const SizedBox(height: 72),
                ClipOval(
                  child: SizedBox(
                    width: 257,
                    height: 257,
                    child: Image.asset(
                      'assets/signInImage.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    'Sign up',
                    style: theme.textTheme.labelLarge?.copyWith(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  
                  // Style is now inherited from the theme
                  child: Text(
                    'Login',
                    style: theme.textTheme.labelLarge?.copyWith(color:Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ), // Empty container for a blank screen
        );
  }
}
