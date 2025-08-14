import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_services.dart';
import 'package:flutter_svg/flutter_svg.dart';



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
          // Navigation is handled by AuthLayout listening to auth state changes.
          Navigator.pushReplacementNamed(context, '/user_profile_setup');
      }} on FirebaseAuthException catch (e) {
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
          margin: const EdgeInsets.only(top:60, left: 22, right: 22,),
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
                height: 80,
                ),
            googleButton(),
            const SizedBox(
              height: 28,
            ),
            enteremail(),
            const SizedBox(
              height: 20,
            ),
            enterpassword(),
            const SizedBox(
              height: 28,
            ),
            signupbutton(),
            if (_errorMessage.isNotEmpty)
               erroRmessage(),
            const SizedBox(height: 8),
            readPrivacypol(),
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
  Widget enteremail(){
    final theme = Theme.of(context);
    return
    TextFormField(
              controller: _emailController,
              maxLength: 128,
              buildCounter: (BuildContext context, { int? currentLength, bool? isFocused, int? maxLength }) => null,
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
            );
  }
  Widget enterpassword(){
    final theme = Theme.of(context);
    return TextFormField(
              controller: _passwordController,
              maxLength: 128,
              buildCounter: (BuildContext context, { int? currentLength, bool? isFocused, int? maxLength }) => null,
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
            );
  }
  Widget signupbutton(){
    final theme = Theme.of(context);
    return ElevatedButton(
              onPressed: _signUp,
              // Style is now inherited from the theme
              child: Text(
                'Sign Up',
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            );
          
  }
  Widget erroRmessage(){ 
    return
    Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );

  }
  Widget readPrivacypol(){
    final theme = Theme.of(context);
    return Row(
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
            );

  }
    
}