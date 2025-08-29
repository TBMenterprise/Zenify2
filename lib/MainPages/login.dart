import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  
  @override
  void initState() {
    super.initState();
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
    controllerEmail.dispose();
    controllerPassword.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    // Simple validation
    if (formKey.currentState!.validate()) {
      // Navigate to chat page without authentication
      Navigator.of(context).pushReplacementNamed('/chat');
    }
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
              Center(child: _emailFormField()),
              SizedBox(height: 16), // 16dp gap
              Center(child: _passwordFormField()),
              SizedBox(height: 8), // 8dp gap
              _resetPassword(),
              SizedBox(height: 16), // 16dp gap
              _loginButton(),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 14), // 24dp gap
              _signUpPrompt(),
              SizedBox(height:25),// tom padding
              
                      ],
                    ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Center(
      child: Column(
        children: [
          Text(
            'Welcome Back!',
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
            'Sign in to continue your journey',
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
            Navigator.pushReplacementNamed(context, '/chat');
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

  Widget _dividerText() {
    return Center(
      child: Text(
        'OR LOG IN WITH EMAIL',
        style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
          color: Color(0xFF9E9E9E),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _emailFormField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _isEmailFocused || controllerEmail.text.isNotEmpty
              ? const Color(0xFF007AFF)
              : const Color(0xFFE5E5E5),
          width: 1.5,
        ),
        boxShadow: _isEmailFocused || controllerEmail.text.isNotEmpty
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
        controller: controllerEmail,
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
              color: _isEmailFocused || controllerEmail.text.isNotEmpty
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFC2C3CB),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D2D2D),
        ),
      ),
    );
  }

  Widget _passwordFormField() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _isPasswordFocused || controllerPassword.text.isNotEmpty
              ? const Color(0xFF007AFF)
              : const Color(0xFFE5E5E5),
          width: 1.5,
        ),
        boxShadow: _isPasswordFocused || controllerPassword.text.isNotEmpty
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
        controller: controllerPassword,
        focusNode: _passwordFocusNode,
        onChanged: (value) => setState(() {}),
        obscureText: !_isPasswordVisible,
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
              color: _isPasswordFocused || controllerPassword.text.isNotEmpty
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFC2C3CB),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF9E9E9E),
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
        ),
      ),
    );
  }

  Widget _resetPassword() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
        child: SizedBox(
          height: 32,
          child: TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              minimumSize: WidgetStateProperty.all(const Size(0, 32)),
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
              Navigator.pushNamed(context, '/forget_password_options');
            },
            child: const Text('Forgot password?'),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
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
            Navigator.of(context).pushReplacementNamed('/chat');
          },
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              'LOG IN',
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


  Widget _signUpPrompt() {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/signup');
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
      ),
    );
  }
}