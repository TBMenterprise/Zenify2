import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_services.dart';
import 'package:mainproject/update_password.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _signOutAndNavigate(BuildContext context) async {
    try {
      await AuthService().signOut();
      if (!context.mounted) return;
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/start_page', (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Failed to sign out'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                _signOutAndNavigate(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
        child: ListView(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: \${snapshot.error}');
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24.0, horizontal: 22.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage:
                              AssetImage('assets/signInImage.png'),
                        ),
                        SizedBox(height: 12),
                        Text(
                          userData['name'] ?? 'No name',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          userData['email'] ?? 'No email',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Age: ${userData['age'] ?? 'Not specified'}',
                           style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 25),
            ...[
              {'title': 'Update Username'},
              {'title': 'Change Password'},
              {'title': 'Support Us'},
              {'title': 'Help & Support'},
              {'title': 'Delete Account'},
            ].map(
              (item) => Column(
                children: [
                  ListTile(
                    title: Text(
                      item['title']!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Icon(Icons.chevron_right),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.white,
                    onTap: () {
                      if (item['title'] == 'Change Password') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdatePasswordPage(),
                          ),
                        );
                      } else if (item['title'] == 'Delete Account') {
                        Navigator.pushNamed(context, '/delete_account');
                      }
                    },
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Center(
                child: TextButton(
                  onPressed: () {
                    _showLogoutConfirmationDialog(context);
                  },
                  child: Text(
                    'Log Out',
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
