
// It is not recommended to add a comment to every line of code, as it can make the code harder to read and maintain.
// Instead, it is better to write self-documenting code and add comments only when necessary to explain complex logic.
// However, as requested, I have added a comment to every line of code in this file.

import '../Authentication/auth_layout.dart'; // Imports the AuthLayout widget, which handles the authentication state.
import 'package:flutter/material.dart'; // Imports the Flutter Material library, which provides UI components that follow Material Design.
import 'chat.dart'; // Imports the ChatPage widget.
import 'login.dart'; // Imports the LoginPage widget.
import 'sign_up.dart'; // Imports the SignUpPage widget.
import 'settings.dart'; // Imports the SettingsPage widget.
import 'package:firebase_core/firebase_core.dart'; // Imports the Firebase Core library, which is required to use Firebase services.
import '../SubPages/reset_password.dart'; // Imports the ResetPasswordPage widget.
import 'start_page.dart'; // Imports the StartPage widget.
import '../Authentication/user_profile_setup.dart'; // Imports the UserProfileSetupPage widget.
import 'package:flutter/foundation.dart' show kIsWeb; // For platform check (web vs others)

// The main entry point of the application.
void main() async {
  // Ensures that the Flutter bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes Firebase (skip on web for preview without web config).
  if (!kIsWeb) {
    await Firebase.initializeApp();
  }

  // Runs the application.
  runApp(const MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  // A constructor for the MyApp widget.
  const MyApp({super.key});

  // Builds the UI for the application.
  @override
  Widget build(BuildContext context) {
    // Returns a MaterialApp widget, which is the root of the application's UI.
    return MaterialApp(
      // Hides the debug banner.
      debugShowCheckedModeBanner: false,
      // Sets the title of the application.
      title: 'ZeniFY',
      // Sets the theme of the application.
      theme: ThemeData(
        // Uses Material 3.
        useMaterial3: true,
        // Sets the color scheme of the application.
        colorScheme: ColorScheme.fromSeed(
          // The seed color for the color scheme.
          seedColor: const Color(0xFF5B95DC),
          // The surface color.
          surface: const Color(0xffF1F5FA),
          // The primary color.
          primary: const Color(0xFF5B95DC),
        ),
        // Sets the default font family.
        fontFamily: 'Literata',
        // Sets the text theme.
        textTheme: const TextTheme(
          // The style for display large text.
          displayLarge: TextStyle(
            // The font family.
            fontFamily: 'Literata',
            // The font size.
            fontSize: 50.52,
            // The color.
            color: Colors.white,
          ),
          // The style for headline medium text.
          headlineMedium: TextStyle(
            // The font family.
            fontFamily: 'Literata',
            // The font size.
            fontSize: 28.43,
            // The color.
            color: Colors.black,
            // The font weight.
            fontWeight: FontWeight.normal,
          ),
          // The style for body medium text.
          bodyMedium: TextStyle(
            // The font family.
            fontFamily: 'Literata',
            // The font size.
            fontSize: 16,
            // The color.
            color: Colors.black87,
          ),
          // The style for label large text.
          labelLarge: TextStyle(fontFamily: 'Literata', fontSize: 21.33),
        ),
        // Sets the theme for elevated buttons.
        elevatedButtonTheme: ElevatedButtonThemeData(
          // The style for elevated buttons.
          style: ElevatedButton.styleFrom(
            // The background color.
            backgroundColor: const Color(0xFF5B95DC),
            // The foreground color.
            foregroundColor: Colors.white,
            // The minimum size.
            minimumSize: const Size(double.infinity, 50),
            // The shape.
            shape: RoundedRectangleBorder(
              // The border radius.
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        // Sets the theme for input decorations.
        inputDecorationTheme: InputDecorationTheme(
          // Whether the input is filled.
          filled: true,
          // The fill color.
          fillColor: const Color(0x24767676),
          // The content padding.
          contentPadding: const EdgeInsets.symmetric(
            // The vertical padding.
            vertical: 26,
            // The horizontal padding.
            horizontal: 20,
          ),
          // The border.
          border: OutlineInputBorder(
            // The border side.
            borderSide: BorderSide.none,
            // The border radius.
            borderRadius: BorderRadius.circular(15),
          ),
          // The hint style.
          hintStyle: const TextStyle(
            // The font family.
            fontFamily: 'Literata',
            // The font size.
            fontSize: 16,
            // The color.
            color: Color(0xFF767676),
          ),
        ),
      ),
      // Sets the initial route of the application.
      initialRoute: kIsWeb ? '/go_premium' : '/auth_layout',
      // Sets the routes of the application.
      routes: {
        // The route for the AuthLayout widget.
        '/auth_layout': (context) => const AuthLayout(),
        // The route for the LoginPage widget.
        '/login': (context) => const LoginPage(),
        // The route for the SignUpPage widget.
        '/signup': (context) => const SignUpPage(),
        // The route for the ChatPage widget.
        '/chat': (context) => const ChatPage(),
        // The route for the SettingsPage widget.
        '/settings': (context) => const SettingsPage(),
        // The route for the ResetPasswordPage widget.
        '/reset_password': (context) => const ResetPasswordPage(),
        // The route for the StartPage widget.
        '/start_page': (context) => const StartPage(),
        // The route for the UserProfileSetupPage widget.
        '/user_profile_setup': (context) => const UserProfileSetupPage(),
      },
    );
  }
}
