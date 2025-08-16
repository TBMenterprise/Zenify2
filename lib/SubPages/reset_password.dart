
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Authentication/auth_services.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  String _successMessage = '';

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _errorMessage = '';
          _successMessage = '';
        });
        await authService.value.resetPassword(
          email: _emailController.text,
        );
        setState(() {
          _successMessage = 'A password reset link has been sent to your email.';
        });
      } on FirebaseAuthException catch (e) {
        setState(() {
          if (e.code == 'user-not-found') {
            _errorMessage =
                'No account found with this email. Please create an account first.';
          } else {
            _errorMessage = 'Failed to send password reset email. Please try again.';
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/background.svg',
                width: 150,
                height: 150,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SvgPicture.asset(
                'assets/background.svg',
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
                      const SizedBox(height: 16.0),
                      _backArrow(),
                      const SizedBox(height: 20.0),
                      _titleText(),
                      const SizedBox(height: 12.0),
                      _subtitleText(),
                      const SizedBox(height: 40.0),
                      _emailFormField(),
                      const SizedBox(height: 32.0),
                      _resetPasswordButton(),
                      if (_errorMessage.isNotEmpty) _errorMessageWidget(),
                      if (_successMessage.isNotEmpty) _successMessageWidget(),
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

  Widget _backArrow() {
    return GestureDetector(
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
    );
  }

  Widget _titleText() {
    return Center(
      child: Text(
        'Forgot Password',
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
    );
  }

  Widget _subtitleText() {
    return Center(
      child: Text(
        'Please enter your email to reset the password',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9E9E9E),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _emailFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: _emailController,
        cursorColor: const Color(0xFF2D2D2D),
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          color: Color(0xFF2D2D2D),
        ),
        decoration: InputDecoration(
          hintText: 'Email address',
          hintStyle: const TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 16,
            color: Color(0xFF9E9E9E),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
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
    );
  }

  Widget _resetPasswordButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: _resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 64, 137, 226),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
        ),
        child: const Text(
          'SEND RESET EMAIL',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1.25,
          ),
        ),
      ),
    );
  }

  Widget _errorMessageWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        _errorMessage,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          color: Colors.redAccent,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _successMessageWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        _successMessage,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          color: Color.fromARGB(255, 64, 137, 226),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
