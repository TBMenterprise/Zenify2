import 'package:flutter/material.dart';
import 'auth_services.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      drawer: menu(context),
      // Using SafeArea to avoid UI elements being obscured by system notches.
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical:24.0),
              child: SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(height: 10),
                  toprow(context),
                  const SizedBox(height: 112),
                  welcomemessage(context),
                  const SizedBox(height: 124),
                  // Additional chat-related widgets will go here.
                  chatContent(context),
                ]),
              ),
            ),
          ),
          chatTextField(context),
          if (MediaQuery.of(context).viewInsets.bottom > 0)
            const SizedBox(height: 10),
        ]),
      ),
    );
     
  }
  Widget menu(BuildContext context){
    final theme = Theme.of(context);
    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration:
                  BoxDecoration(color: theme.colorScheme.primary),
              child: Text(
                'ZeniFY Menu',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout', style: theme.textTheme.bodyMedium),
              onTap: () {
                authService.value.signOut();
                // To log out, we navigate back to the StartPage and remove all previous routes.
                Navigator.pushNamedAndRemoveUntil(
                    context, '/start_page', (Route<dynamic> route) => false);
              },
            ),
            // You can add other options like 'Profile', 'Settings' etc. here
          ],
        ),
      );
  }
  
  Widget toprow(BuildContext context){
    return Row(
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
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                    ],
                  );
    }
    Widget welcomemessage(BuildContext context){
      final theme = Theme.of(context);
      return Text(
                    "What's on your mind, Benjamin?",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  );
      }
    Widget chatContent(BuildContext context){
      final theme = Theme.of(context);
      return Center(
                    child: Text('Chat content will appear here.', style: theme.textTheme.bodyMedium),
                  ); }
    Widget chatTextField(BuildContext context){
      final theme = Theme.of(context);
      return SizedBox( height: 60,
          child :TextField(
            cursorColor: theme.colorScheme.primary,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Type away',
              // By default, your theme's input decoration has an invisible border.
              // To make it visible, you need to define the border for each state.
              // This is the border when the field is enabled but not focused.
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              // This is the border when the field has focus (is being typed in).
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(100.0),
                  topRight: Radius.circular(100.0),
                  bottomLeft: Radius.circular(100.0),
                  bottomRight: Radius.circular(100.0),

                ),
              ),
            ),
          ),
          ); }
}

