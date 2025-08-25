import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Authentication/auth_services.dart';
import 'package:mainproject/widgets/settings_bottom_sheet.dart';

void showUpdatePasswordBottomSheet(BuildContext context) {
  showSettingsBottomSheet(
    context,
    UpdatePasswordPage(),
  );
}

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await authService.value.resetPasswordFromCurrentPassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          email: authService.value.currentUser!.email!,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password updated successfully!'),
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
        Navigator.of(context).pop(true);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(e.message ?? 'Failed to update password. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
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
                'Change Password',
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
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    _subtitleText(),
                    const SizedBox(height: 32),
                    _currentPasswordField(),
                    const SizedBox(height: 16),
                    _newPasswordField(),
                    const SizedBox(height: 16),
                    _confirmPasswordField(),
                    const SizedBox(height: 32),
                    _updateButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _titleText() {
    return Center(
      child: Text(
        'Change Password',
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
        'Enter your current and new password',
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

  InputDecoration _passwordDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
    );
  }

  Widget _currentPasswordField() {
    return TextFormField(
      controller: _currentPasswordController,
      obscureText: !_isCurrentVisible,
      cursorColor: const Color(0xFF2D2D2D),
      style: const TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        color: Color(0xFF2D2D2D),
      ),
      decoration: _passwordDecoration('Current password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isCurrentVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF9E9E9E),
          ),
          onPressed: () => setState(() => _isCurrentVisible = !_isCurrentVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your current password';
        }
        return null;
      },
    );
  }

  Widget _newPasswordField() {
    return TextFormField(
      controller: _newPasswordController,
      obscureText: !_isNewVisible,
      cursorColor: const Color(0xFF2D2D2D),
      style: const TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        color: Color(0xFF2D2D2D),
      ),
      decoration: _passwordDecoration('New password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isNewVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF9E9E9E),
          ),
          onPressed: () => setState(() => _isNewVisible = !_isNewVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a new password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmVisible,
      cursorColor: const Color(0xFF2D2D2D),
      style: const TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        color: Color(0xFF2D2D2D),
      ),
      decoration: _passwordDecoration('Confirm new password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF9E9E9E),
          ),
          onPressed: () => setState(() => _isConfirmVisible = !_isConfirmVisible),
        ),
      ),
      validator: (value) {
        if (value != _newPasswordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _updateButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: _updatePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 64, 137, 226),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
        ),
        child: const Text(
          'UPDATE PASSWORD',
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