import 'package:flutter/material.dart';
import 'package:mainproject/login.dart';
import 'package:mainproject/sign_up.dart';



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // ...existing code...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZeniFY',
      theme: ThemeData(
        primaryColor: const Color(0xFF5B95DC),
        fontFamily: 'Literata',
      ),
      home: StartPage(
      )
    );
  }

  // ...existing code...
}


class StartPage extends StatelessWidget {
  const StartPage({super.key});

  // This widget is the root of your application.
  // ...existing code...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF8CB2E1),
        body: Container(
          margin: EdgeInsets.only(bottom: 60, left: 26, right: 26),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'ZeniFY',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 50.52,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 72),
                ClipOval(
                  child: SizedBox(
                    width: 257,
                    height: 257,
                    child: Image(
                      image: AssetImage('assets/signInImage.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                SizedBox(height: 100),
                ElevatedButton(
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage()),
                  );},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontFamily: 'Literata', fontSize: 21.33),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5B95DC),
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontFamily: 'Literata', fontSize: 21.33),
                  ),
                ),
              ],
            ),
          ),
        ), // Empty container for a blank screen
      );
  }

  // ...existing code...
}
