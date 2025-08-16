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
      if (_selectedAge! < 18) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You must be at least 18 years old.')),
          );
        }
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await authService.value.saveUserProfile(
          uid: user.uid,
          name: _nameController.text,
          age: _selectedAge!,
        );
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/chat',
            (route) => false,
          );
        }
      } else {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _backArrow(),
                  const SizedBox(height: 20),
                  _titleText(),
                  const SizedBox(height: 12),
                  _subtitleText(),
                  const SizedBox(height: 32),
                  _nameField(),
                  const SizedBox(height: 16),
                  _ageField(),
                  const SizedBox(height: 32),
                  _saveButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backArrow() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: Color(0xFF2D2D2D),
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return Center(
      child: Text(
        'Complete Your Profile',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontWeight: FontWeight.w700,
          fontSize: 30,
          height: 1.2,
          letterSpacing: -0.2,
          color: Color(0xFF3A3A3C),
        ),
      ),
    );
  }

  Widget _subtitleText() {
    return Center(
      child: Text(
        'Tell us a bit about yourself',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF9E9E9E),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _nameField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextFormField(
        controller: _nameController,
        cursorColor: const Color(0xFF2D2D2D),
        style: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          color: Color(0xFF2D2D2D),
        ),
        decoration: InputDecoration(
          hintText: 'Full Name',
          hintStyle: const TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: 16,
            color: Color(0xFF9E9E9E),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
    );
  }

  Widget _ageField() {
    return DropdownButtonFormField<int>(
      value: _selectedAge,
      items: List.generate(100, (index) => index + 1)
          .map((age) => DropdownMenuItem(value: age, child: Text('$age')))
          .toList(),
      onChanged: (value) => setState(() => _selectedAge = value),
      decoration: InputDecoration(
        hintText: 'Age',
        hintStyle: const TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: 16,
          color: Color(0xFF9E9E9E),
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      ),
      style: const TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        color: Color(0xFF2D2D2D),
      ),
      validator: (value) {
        if (value == null) {
          return 'Please select your age';
        }
        if (value < 18) {
          return 'You must be at least 18 years old';
        }
        return null;
      },
    );
  }

  Widget _saveButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 64, 137, 226),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
        ),
        child: const Text(
          'SAVE AND CONTINUE',
          style: TextStyle(
            fontFamily: 'HelveticaNeue',
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 1.25,
          ),
        ),
      ),
    );
  }
}