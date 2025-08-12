import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  String _errorMessage = '';

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_isChecked) {
        setState(() {
          _errorMessage = 'Please accept the Privacy Policy to continue.';
        });
        return;
      }
      try {
        setState(() {
          _errorMessage = '';
        });
        await authService.value.createAccount(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/chat');
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? 'An error occurred.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor is now inherited from the theme's colorScheme.background
      body: Container(
          margin: const EdgeInsets.only(top: 116, left: 22, right: 22),
          child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
              children: [
              Text(
              'Create your account',
              style: theme.textTheme.headlineMedium,
            ),

              const SizedBox(
                height: 124,
                ),

            TextFormField(
              controller: _emailController,
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Email Address',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!EmailValidator.validate(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
             TextFormField(
              controller: _passwordController,
              obscureText: true,
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 28,
            ),
            ElevatedButton(
              onPressed: _signUp,
              // Style is now inherited from the theme
              child: Text(
                'Sign Up',
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
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
      ),
    );
  }
}