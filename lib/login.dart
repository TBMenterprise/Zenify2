import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }


  
  void signIn() async {
    try {
      await authService.value.signIn(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/chat');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An unknown error occurred.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // backgroundColor is inherited from theme
      body: Container(
        margin: const EdgeInsets.only(top: 60, left: 22, right: 22),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Use Align to move a single widget within a larger space.
                  Text('Welcome Back', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 80),
                  googleButton(),
                  const SizedBox(height: 28),
                  _emailFormField(),
                  const SizedBox(height: 20),
                  _passwordFormField(),
                  const SizedBox(height: 20),
                  if (errorMessage.isNotEmpty)
                   _errorMessage(),
                  _loginButton(),
                  const SizedBox(height: 9),
                  _resetPassword(),
                  const SizedBox(height: 60),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



   Widget googleButton() {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        // TODO: Implement Google Sign-In
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: theme.colorScheme.primary, width: 2),
          foregroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      // The Row's mainAxisAlignment will handle the centering.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/bluegoogleicon.svg',
            height: 22.0,
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Continue with Google',
            style: TextStyle(fontSize: 17),
          ),
        ],
      ),
  );
  }

  Widget _emailFormField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controllerEmail,
      cursorColor: theme.colorScheme.primary,
      decoration: const InputDecoration(hintText: 'Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
    );
  }

  Widget _passwordFormField() {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controllerPassword,
      obscureText: true,
      cursorColor: theme.colorScheme.primary,
      decoration: const InputDecoration(hintText: 'Password'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _errorMessage() {
    return Text(
      errorMessage,
      style: const TextStyle(color: Colors.redAccent),
    );
  }

  Widget _loginButton() {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          signIn();
        }
      },
      child: Text(
        'Login',
        style: theme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _resetPassword() {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/reset_password');
      },
      child: Text(
        'Reset Password',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
