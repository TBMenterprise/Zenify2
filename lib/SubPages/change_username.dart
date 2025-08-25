import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentication/auth_services.dart';
import 'package:mainproject/widgets/settings_bottom_sheet.dart';

void showChangeUsernameBottomSheet(BuildContext context) {
  showSettingsBottomSheet(
    context,
    ChangeUsernamePage(),
  );
}

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final _newUsernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUsername();
  }

  @override
  void dispose() {
    _newUsernameController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUsername() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final userData = doc.data() as Map<String, dynamic>;
          setState(() {
            _currentUsername = userData['name'] ?? '';
            _newUsernameController.text = _currentUsername;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load current username: $e';
      });
    }
  }

  Future<void> _updateUsername() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _errorMessage = 'No user logged in.';
      });
      return;
    }

    try {
      setState(() {
        _errorMessage = '';
      });

      // Update in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'name': _newUsernameController.text.trim()});

      // Update Firebase Auth display name
      await authService.value.updateUsername(username: _newUsernameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Username updated successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: const EdgeInsets.only(
              bottom: 20,
              right: 20,
              left: 20,
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update username: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'Change Username',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
        // Body
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12.0),
                    // Subtitle
                    Center(
                      child: Text(
                        'Enter your new username',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32.0),
                  // Username field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextFormField(
                      controller: _newUsernameController,
                      cursorColor: Color(0xFF2D2D2D),
                      style: TextStyle(
                        fontFamily: 'HelveticaNeue',
                        fontSize: 16,
                        color: Color(0xFF2D2D2D),
                      ),
                      decoration: InputDecoration(
                        hintText: 'New Username',
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
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a username';
                        }
                        if (value.trim().length < 2) {
                          return 'Username must be at least 2 characters';
                        }
                        if (value.trim().length > 30) {
                          return 'Username must be less than 30 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  // Update username button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: ElevatedButton(
                      onPressed: _updateUsername,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 64, 137, 226),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        minimumSize: Size(double.infinity, 56),
                        elevation: 0,
                      ),
                      child: Text(
                        'UPDATE USERNAME',
                        style: TextStyle(
                          fontFamily: 'HelveticaNeue',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 16.0),
                    Center(
                      child: Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'HelveticaNeue',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
        ),
    ],
    );
  }
}