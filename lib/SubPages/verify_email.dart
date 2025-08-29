import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  String _errorMessage = '';

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(String value, int index) {
    setState(() {
      _errorMessage = '';
    });
    
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifyCode() {
    String code = _controllers.map((controller) => controller.text).join();
    
    if (code.length != 4) {
      setState(() {
        _errorMessage = 'Please enter the complete verification code';
      });
      return;
    }
    
    // Simulate verification
    if (code == '1234') {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        _errorMessage = 'Invalid verification code. Please try again.';
      });
    }
  }

  void _resendCode() {
    // Simulate resending code
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification code sent successfully'),
        backgroundColor: Color(0xFF007AFF),
      ),
    );
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
                children: [
                  const SizedBox(height: 16.0),
                  _backArrow(),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _titleText(),
                            const SizedBox(height: 12.0),
                            _subtitleText(),
                            const SizedBox(height: 40.0),
                            _otpInputFields(),
                            if (_errorMessage.isNotEmpty) _errorMessageWidget(),
                            const SizedBox(height: 32.0),
                            _verifyButton(),
                            const SizedBox(height: 16.0),
                            _resendCodeButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backArrow() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF333333),
            size: 18,
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return const Text(
      'Verify Email',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.56,
        color: Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _subtitleText() {
    return Text(
      'We have sent code to your phone number\n${widget.email}',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8E8E93),
        height: 1.4,
        letterSpacing: -0.28,
      ),
    );
  }

  Widget _otpInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _controllers[index].text.isNotEmpty 
                  ? const Color(0xFF007AFF) 
                  : const Color(0xFFE5E5E5),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) => _onDigitChanged(value, index),
          ),
        );
      }),
    );
  }

  Widget _errorMessageWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        _errorMessage,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFFFF3B30),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.28,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _verifyButton() {
    return Container(
      height: 60,
      width: double.infinity,
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
        onPressed: _verifyCode,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 0,
        ),
        child: const Text(
          'Verify',
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

  Widget _resendCodeButton() {
    return TextButton(
      onPressed: _resendCode,
      child: const Text(
        'Send Again',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF8E8E93),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.32,
        ),
      ),
    );
  }
}