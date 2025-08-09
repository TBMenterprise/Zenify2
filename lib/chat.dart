import 'package:flutter/material.dart';
import 'package:mainproject/start_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'ZeniFY Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                // To log out, we navigate back to the StartPage and remove all previous routes.
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const StartPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            // You can add other options like 'Profile', 'Settings' etc. here
          ],
        ),
      ),
      // Using SafeArea to avoid UI elements being obscured by system notches.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Use a Builder to get the correct context for Scaffold.of()
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.black),
                  onPressed: () {
                    // Handle settings action
                  },
                ),
              ],
            ),
            const SizedBox(height: 112),
            const Text(
              "What's on your mind, Benjamin?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Literata',
                fontSize: 28.43,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 124),
            // Additional chat-related widgets will go here.
            const Expanded(
              child: Center(
                child: Text('Chat content will appear here.'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
