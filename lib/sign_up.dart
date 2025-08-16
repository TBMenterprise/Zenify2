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
    // Using Theme.of(context) inline in widgets where needed; no local variable to avoid unused warnings

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/background.svg', // Assuming this is your pattern SVG
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SvgPicture.asset(
                'assets/background.svg', // Assuming this is your pattern SVG
                width: 150,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16.0), // 16dp from SafeArea top
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF2D2D2D), width: 1),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Color(0xFF2D2D2D),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: Text(
                          'Create your account',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            letterSpacing: -0.2,
                            color: Color(0xFF3A3A3C),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      googleButton(),
                      const SizedBox(height: 32.0),
                      Center(
                        child: Text(
                          'OR LOG IN WITH EMAIL',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      enteremail(),
                      const SizedBox(height: 16.0),
                      enterpassword(),
                      const SizedBox(height: 12.0),
                      readPrivacypol(),
                      const SizedBox(height: 24.0),
                      signupbutton(),
                      if (_errorMessage.isNotEmpty) erroRmessage(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement Google Sign-In
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: Color(0xFFE5E5E5), width: 1),
          ),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/bluegoogleicon.svg',
              height: 24.0,
            ),
            const SizedBox(width: 16.0),
            const Text(
              'CONTINUE WITH GOOGLE',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.25,
                color: Color.fromARGB(255, 83, 79, 77),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget enteremail(){
    final theme = Theme.of(context);
    return
    TextFormField(
              controller: _emailController,
              maxLength: 128,
              buildCounter: (BuildContext context, { required int currentLength, required bool isFocused, required int? maxLength }) => null,
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Email Address',
                hintStyle: TextStyle(
                  fontFamily: 'HelveticaNeue',
                ),

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
              buildCounter: (BuildContext context, { required int currentLength, required bool isFocused, required int? maxLength }) => null,
              obscureText: true,
              cursorColor: theme.colorScheme.primary,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(
                  fontFamily: 'HelveticaNeue',
                ),

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
    // No need for a local theme variable here
    return ElevatedButton(
              onPressed: _signUp,
              // Style is now inherited from the theme
              child: const Text(
                'GET STARTED',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
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
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9E9E9E),
                    ),
                    children: <TextSpan>[
                      const TextSpan(text: 'I have read the '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.w400,
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