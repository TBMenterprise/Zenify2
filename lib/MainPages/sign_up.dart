
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isFullNameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  
  final FocusNode _fullNameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();



  @override
  void initState() {
    super.initState();
    _fullNameFocusNode.addListener(() {
      setState(() {
        _isFullNameFocused = _fullNameFocusNode.hasFocus;
      });
    });
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.06, // Responsive padding
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),
                      GestureDetector(
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
                      SizedBox(height: screenHeight * 0.04),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Create your Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: screenWidth * 0.07, // Responsive font size
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                                letterSpacing: -0.5,
                                color: const Color(0xFF2D2D2D),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'Join us and start your journey',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF9E9E9E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      _googleButton(),
                      const SizedBox(height: 24.0),
                      Center(
                        child: Text(
                          'OR SIGN UP WITH EMAIL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      _fullNameFormField(),
                      const SizedBox(height: 12.0),
                      _emailFormField(),
                      const SizedBox(height: 12.0),
                      _passwordFormField(),
                      const SizedBox(height: 32.0),
                      _registerButton(),
                      const SizedBox(height: 24.0),
                      _signInLink(),
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

  Widget _googleButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pushNamed(context, '/profile_setup');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/bluegoogleicon.svg',
                  height: 24,
                  width: 24,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF4285F4),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'CONTINUE WITH GOOGLE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D2D2D),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fullNameFormField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFF8F8F8),
        border: _isFullNameFocused || _fullNameController.text.isNotEmpty
            ? Border.all(color: const Color(0xFF007AFF), width: 2.0)
            : Border.all(color: Colors.transparent, width: 2.0),
        boxShadow: _isFullNameFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: _fullNameController,
        focusNode: _fullNameFocusNode,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Full Name',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFC2C3CB),
            letterSpacing: -0.32,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Icon(
              Icons.person_outline,
              size: 24,
              color: _isFullNameFocused || _fullNameController.text.isNotEmpty
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFC2C3CB),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _emailFormField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFF8F8F8),
        border: _isEmailFocused || _emailController.text.isNotEmpty
            ? Border.all(color: const Color(0xFF007AFF), width: 2.0)
            : Border.all(color: Colors.transparent, width: 2.0),
        boxShadow: _isEmailFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        onChanged: (value) => setState(() {}),
        keyboardType: TextInputType.emailAddress,
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
            child: Icon(
              Icons.email_outlined,
              size: 24,
              color: _isEmailFocused || _emailController.text.isNotEmpty
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFC2C3CB),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _passwordFormField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFF8F8F8),
        border: _isPasswordFocused || _passwordController.text.isNotEmpty
            ? Border.all(color: const Color(0xFF007AFF), width: 2.0)
            : Border.all(color: Colors.transparent, width: 2.0),
        boxShadow: _isPasswordFocused
            ? [
                BoxShadow(
                  color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: _passwordController,
        focusNode: _passwordFocusNode,
        onChanged: (value) => setState(() {}),
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFC2C3CB),
            letterSpacing: -0.32,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Icon(
              Icons.lock_outline,
              size: 24,
              color: _isPasswordFocused || _passwordController.text.isNotEmpty
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFC2C3CB),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFF007AFF), Color(0xFF0056CC)],
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.pushNamed(context, '/profile_setup');
          },
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              'Register',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInLink() {
    return Center(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          Navigator.pop(context);
        },
        child: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9E9E9E),
            ),
            children: <TextSpan>[
              const TextSpan(text: 'Already Have An Account? '),
              TextSpan(
                text: 'Sign In',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}