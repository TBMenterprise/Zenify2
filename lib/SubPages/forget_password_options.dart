import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgetPasswordOptionsPage extends StatefulWidget {
  const ForgetPasswordOptionsPage({super.key});

  @override
  State<ForgetPasswordOptionsPage> createState() => _ForgetPasswordOptionsPageState();
}

class _ForgetPasswordOptionsPageState extends State<ForgetPasswordOptionsPage> {
  String _selectedOption = '';

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _proceedNext() {
    if (_selectedOption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a recovery method'),
          backgroundColor: Color(0xFFFF3B30),
        ),
      );
      return;
    }

    if (_selectedOption == 'email') {
      Navigator.pushNamed(context, '/reset_password');
    } else {
      // Navigate to phone verification (can be implemented later)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone verification coming soon'),
          backgroundColor: Color(0xFF007AFF),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  _backArrow(),
                  const SizedBox(height: 40.0),
                  _titleText(),
                  const SizedBox(height: 12.0),
                  _subtitleText(),
                  const SizedBox(height: 60.0),
                  _emailOption(),
                  const SizedBox(height: 20.0),
                  _phoneOption(),
                  const Spacer(),
                  _nextButton(),
                  const SizedBox(height: 32.0),
                ],
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
    return const Text(
      'Forget Password',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.64,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _subtitleText() {
    return const Text(
      'Select which contact details should we use\nto reset your password',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8E8E93),
        height: 1.4,
        letterSpacing: -0.32,
      ),
    );
  }

  Widget _emailOption() {
    bool isSelected = _selectedOption == 'email';
    
    return GestureDetector(
      onTap: () => _selectOption('email'),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFE5E5E5),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.email_outlined,
                color: Color(0xFF007AFF),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Send to your email',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF007AFF),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _phoneOption() {
    bool isSelected = _selectedOption == 'phone';
    
    return GestureDetector(
      onTap: () => _selectOption('phone'),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFE5E5E5),
            width: isSelected ? 2.0 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.phone_outlined,
                color: Color(0xFF007AFF),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                      letterSpacing: -0.36,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Send to your phone',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E8E93),
                      letterSpacing: -0.28,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF007AFF),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _nextButton() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: _selectedOption.isNotEmpty
            ? const LinearGradient(
                colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: _selectedOption.isEmpty ? const Color(0xFFE5E5E5) : null,
        boxShadow: _selectedOption.isNotEmpty
            ? [
                BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: _selectedOption.isNotEmpty ? _proceedNext : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
          disabledBackgroundColor: Colors.transparent,
        ),
        child: Text(
          'Next',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: _selectedOption.isNotEmpty ? Colors.white : const Color(0xFF8E8E93),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: -0.36,
          ),
        ),
      ),
    );
  }
}