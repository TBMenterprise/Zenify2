import 'package:flutter/material.dart';
import '../SubPages/update_password.dart';
import '../SubPages/go_premium.dart';
import '../SubPages/delete_account.dart';
import '../SubPages/change_username.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void showChangeUsernameBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: const ChangeUsernamePage(),
        ),
      ),
    );
  }
  
  void _signOutAndNavigate(BuildContext context) async {
    // Navigate to start page without authentication
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/start_page', (Route<dynamic> route) => false);
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              fontFamily: 'HelveticaNeue',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF757575),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                foregroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                minimumSize: const Size(120, 44),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _signOutAndNavigate(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                minimumSize: const Size(140, 44),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  fontFamily: 'HelveticaNeue',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _fetchProfileWithBackoff() async {
    // Return mock user data instead of fetching from Firebase
    return {
      'name': 'User',
      'email': 'user@example.com',
      'premium': false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D2D2D)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontWeight: FontWeight.w700,
            fontSize: 28,
            color: Color(0xFF3A3A3C),
            height: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          return Future.delayed(const Duration(milliseconds: 100));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Profile Card
                  FutureBuilder<Map<String, dynamic>>(
                    future: _fetchProfileWithBackoff(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        final theme = Theme.of(context);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "We couldn't load your profile right now.",
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: theme.colorScheme.primary, width: 1.5),
                                foregroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                minimumSize: const Size(120, 36),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        );
                      }
                      final userData = snapshot.data ?? {};
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
                              const CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    AssetImage('assets/signInImage.png'),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                userData['name'] ?? 'No name',
                                style: const TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Color(0xFF2D2D2D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userData['email'] ?? 'No email',
                                style: const TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF6D6D6D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Age: ${userData['age'] ?? 'Not specified'}',
                                style: const TextStyle(
                                  fontFamily: 'HelveticaNeue',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Color(0xFF6D6D6D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  // List Tiles
                  ...[
                    {'title': 'Update Username'},
                    {'title': 'Change Password'},
                    {'title': 'Go Premium'},
                    {'title': 'Support Us'},
                    {'title': 'Help & Support'},
                    {'title': 'Delete Account'},
                  ].map(
                    (item) => Column(
                      children: [
                        ListTile(
                          title: Text(
                            item['title']!,
                            style: const TextStyle(
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right,
                              color: Color(0xFF9E9E9E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          tileColor: Colors.white,
                          onTap: () {
                            if (item['title'] == 'Change Password') {
                              showUpdatePasswordBottomSheet(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UpdatePasswordPage(),
                                ),
                              );
                            } else if (item['title'] == 'Delete Account') {
                              showDeleteAccountBottomSheet(context);
                              Navigator.pushNamed(context, '/delete_account');
                            } else if (item['title'] == 'Update Username') {
                              showChangeUsernameBottomSheet(context);
                            } else if (item['title'] == 'Go Premium') {
                              showGoPremiumBottomSheet(context);
                              Navigator.pushNamed(context, '/change_username');
                            }
                          },
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Log Out Button
                  ListTile(
                    title: Center(
                      child: TextButton(
                        onPressed: () {
                          _showLogoutConfirmationDialog(context);
                        },
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
    }
}