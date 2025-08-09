import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor is now inherited from the theme's colorScheme.background
      body: Container(
          margin: const EdgeInsets.only(top: 116, left: 22, right: 22),
          child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
              Text(
              'Create your account',
              style: theme.textTheme.headlineMedium,
            ),

              const SizedBox(
                height: 124,
                ),
            TextField(
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Full Name',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Email Address',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
             TextField(
              obscureText: true,
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            const SizedBox(
              height: 28,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/chat');
              },
              // Style is now inherited from the theme
              child: Text(
                'Sign Up',
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: <TextSpan>[
                      const TextSpan(text: 'I have read the '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                  activeColor: theme.colorScheme.primary,
                ),
              ],
            ),
              ],
           ),
          ),
         ),
      ),
      );
    
    
  }
}