import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F5FA),
      body: Container
      (margin: EdgeInsets.only(top: 116, left: 22, right: 22),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Welcome Back',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 28.43,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 124),
              TextField(
                cursorColor: const Color(0xFF5B95DC),
                decoration: InputDecoration(
                  fillColor: Color(0x24767676),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 16,
                    color: Color(0xFF767676),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                cursorColor: const Color(0xFF5B95DC),
                decoration: InputDecoration(
                  fillColor: Color(0x24767676),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 16,
                    color: Color(0xFF767676),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle login action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5B95DC),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50), // Button color
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Button padding
                ),
                child: Text('Login', style: TextStyle(fontFamily:'Literata', fontSize : 18)),
              ),
              SizedBox(height: 9),
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
