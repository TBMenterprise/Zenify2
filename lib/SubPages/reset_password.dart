
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _successMessage = '';

  void _resetPassword() async {
    // Navigate directly to email verification page without validation
    Navigator.pushNamed(
      context, 
      '/verify_email',
      arguments: _emailController.text.isEmpty ? 'user@example.com' : _emailController.text,
    );
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
          color: const Color(0xFFF8F8F8),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back,
            color: Color(0xFF1A1A1A),
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
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.2,
          letterSpacing: -0.64,
          color: Color(0xFF1A1A1A),
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
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF8E8E93),
          height: 1.4,
          letterSpacing: -0.32,
        ),
      ),
    );
  }

  Widget _emailFormField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
          width: 1.5,
        ),
      ),
      child: TextFormField(
        controller: _emailController,
        cursorColor: const Color(0xFF007AFF),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1A1A1A),
          letterSpacing: -0.32,
        ),
        decoration: InputDecoration(
          hintText: 'Enter Your Email',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFC2C3CB),
            letterSpacing: -0.32,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(18.0),
            child: const Icon(
              Icons.email_outlined,
              size: 24,
              color: Color(0xFFC2C3CB),
            ),
          ),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF007AFF).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _resetPassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          minimumSize: const Size(double.infinity, 60),
          elevation: 0,
        ),
        child: const Text(
          'Reset',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: -0.36,
          ),
        ),
      ),
    );
  }

  Widget _successMessageWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        _successMessage,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF007AFF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.28,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
