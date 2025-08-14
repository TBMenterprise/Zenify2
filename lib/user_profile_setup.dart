import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_services.dart';

class UserProfileSetupPage extends StatefulWidget {
  const UserProfileSetupPage({super.key});

  @override
  State<UserProfileSetupPage> createState() => _UserProfileSetupPageState();
}

class _UserProfileSetupPageState extends State<UserProfileSetupPage> {
  final _nameController = TextEditingController();
  int? _selectedAge;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
  
    super.dispose();
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await authService.value.saveUserProfile(
          uid: user.uid,
          name: _nameController.text,
          age: _selectedAge!, // Use _selectedAge directly
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/chat');
        }
      } else {
        // Handle case where user is not logged in (shouldn't happen after signup)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not logged in.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tell us a bit about yourself',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<int>(
                  value: _selectedAge,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  items: List.generate(100, (index) => index + 1)
                      .map((age) => DropdownMenuItem(
                            value: age,
                            child: Text('$age'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAge = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Save Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}