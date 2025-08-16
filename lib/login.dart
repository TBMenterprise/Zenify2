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
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
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
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16), // 16dp below SafeArea
              _backArrow(),
              SizedBox(height: 20), // 20dp gap
              _titleText(),
              SizedBox(height: 32), // 32dp gap
              _googleButton(),
              SizedBox(height: 32), // 32dp gap
              _dividerText(),
              SizedBox(height: 24), // 24dp gap
              _emailFormField(),
              SizedBox(height: 16), // 16dp gap
              _passwordFormField(),
              SizedBox(height: 8), // 8dp gap
              _resetPassword(),
              SizedBox(height: 16), // 16dp gap
              _loginButton(),
              SizedBox(height: 14), // 24dp gap
              _signUpPrompt(),
              SizedBox(height:25),// tom padding
            ],
            ),
          ),
          ),
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
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return Text(
      'Welcome Back!',
      style: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontWeight: FontWeight.w700, // Bold
        fontSize: 28,
        height: 1.2,
        color: Color(0xFF212121),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _googleButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement Google Sign-In
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Color(0xFFE5E5E5), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          minimumSize: Size(double.infinity, 56),
          padding: EdgeInsets.symmetric(horizontal: 20),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/bluegoogleicon.svg',
              height: 24,
              width: 24,
            ),
            SizedBox(width: 12), // 12dp gap
            Text(
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

  Widget _dividerText() {
    return Text(
      'OR LOG IN WITH EMAIL',
      style: TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: Color(0xFF9E9E9E),
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _emailFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controllerEmail,
        cursorColor: Color(0xFF2D2D2D),
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          color: Color(0xFF2D2D2D),
        ),
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 16,
            color: Color(0xFF9E9E9E),
          ),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
      ),
    );
  }

  Widget _passwordFormField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: controllerPassword,
        obscureText: !_isPasswordVisible,
        cursorColor: Color(0xFF2D2D2D),
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          color: Color(0xFF2D2D2D),
        ),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 16,
            color: Color(0xFF9E9E9E),
          ),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF9E9E9E),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }

  Widget _resetPassword() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0), // 24dp + 18dp = 42dp from screen edge
        child: SizedBox(
          height: 40,
          child: TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all(const Size(0, 40)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,

              foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                return states.contains(WidgetState.pressed)
                    ? const Color(0xFF5E5E5E)
                    : const Color(0xFF757575);
              }),
              textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
                return TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  decoration: states.contains(WidgetState.pressed)
                      ? TextDecoration.underline
                      : TextDecoration.none,
                );
              }),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/reset_password');
            },
            child: const Text('Forgot password?'),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            signIn();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:  const Color.fromARGB(255, 64, 137, 226),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          minimumSize: Size(double.infinity, 56),
          elevation: 0,
        ),
        child: Text(
          'LOG IN',
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

  Widget _signUpPrompt() {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to Sign Up page
      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E9E9E),
          ),
          children: <TextSpan>[
            TextSpan(text: "DON'T HAVE AN ACCOUNT? "),
            TextSpan(
              text: 'SIGN UP',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                color:  const Color.fromARGB(255, 64, 137, 226),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}