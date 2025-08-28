import 'package:flutter/material.dart';
import 'package:mainproject/widgets/settings_bottom_sheet.dart';

void showDeleteAccountBottomSheet(BuildContext context) {
  showSettingsBottomSheet(
    context,
    DeleteAccountPage(),
  );
}

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Method removed as it was unused

  Future<void> _deleteAccount() async {
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirm Account Deletion',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212121),
              ),
            ),
            content: const Text(
              'Are you sure you want to delete your account?',
              style: TextStyle(
                fontFamily: 'HelveticaNeue',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF757575),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey,
                      ),
                      child: const Text('CANCEL'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        // Navigate to start page
                        Navigator.of(context).pushNamedAndRemoveUntil('/start_page', (route) => false);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('DELETE'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
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
                _passwordField(),
                const SizedBox(height: 16),
                _confirmPasswordField(),
                const SizedBox(height: 32),
                _deleteButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _subtitleText() {
    return Center(
      child: Text(
        'Please confirm your password to delete your account',
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

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      cursorColor: const Color(0xFF2D2D2D),
      style: const TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        color: Color(0xFF2D2D2D),
      ),
      decoration: _passwordDecoration('Current Password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF9E9E9E),
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _confirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      cursorColor: const Color(0xFF2D2D2D),
      style: const TextStyle(
        fontFamily: 'HelveticaNeue',
        fontSize: 16,
        color: Color(0xFF2D2D2D),
      ),
      decoration: _passwordDecoration('Confirm Password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: const Color(0xFF9E9E9E),
          ),
          onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _deleteButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _deleteAccount();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
        ),
        child: const Text(
          'DELETE ACCOUNT',
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