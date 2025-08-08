import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF1F5FA),
      body: Container(
          margin: EdgeInsets.only(top: 116, left: 22, right: 22),
          child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
              Text(
              'Create your account',
              style: TextStyle(
                fontFamily: 'Literata',
                fontSize: 28.43,
                color: Colors.black,
              ),
            ),

              SizedBox(
                height: 124,
                ),
            TextField(
              cursorColor: const Color(0xFF5B95DC),
              decoration: InputDecoration(
                fillColor: Color(0x24767676),
                hintText: 'Full Name',
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
            SizedBox(
              height: 20,
            ),
            TextField(
              cursorColor: const Color(0xFF5B95DC),
              decoration: InputDecoration(
                fillColor: Color(0x24767676),
                hintText: 'Email Address',
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
            SizedBox(
              height: 20,
            ),
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
            SizedBox(
              height: 28,
            ),
            ElevatedButton(
              onPressed: () {
                // Add your sign-up logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5B95DC),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Sign Up',
                style: TextStyle(fontFamily: 'Literata', fontSize: 21.33),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Literata',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'I have read the '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF5B95DC),
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
                  activeColor: const Color(0xFF5B95DC),
                ),
              ],
            ),
              ],
           ),
          ),
         ),
      ),
      );
    
    
  }
}