
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();



  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
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
                    _googleButton(),
                    const SizedBox(height: 32.0),
                    Center(
                      child: Text(
                        'OR SIGN UP WITH EMAIL',
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
                    _emailFormField(),
                    const SizedBox(height: 16.0),
                    _passwordFormField(),
                    const SizedBox(height: 12.0),
                    _privacyPolicyCheckbox(),
                    const SizedBox(height: 24.0),
                    _signUpButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/chat');
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

  Widget _emailFormField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: TextStyle(
          fontFamily: 'HelveticaNeue',
        ),
      ),
    );
  }

  Widget _passwordFormField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        hintStyle: TextStyle(
          fontFamily: 'HelveticaNeue',
        ),
      ),
    );
  }

  Widget _signUpButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/chat');
      },
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

  Widget _privacyPolicyCheckbox() {
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
          value: true, // Always true for fake authentication
          onChanged: (bool? value) {},
          activeColor: theme.colorScheme.primary,
        ),
      ],
    );
  }
}