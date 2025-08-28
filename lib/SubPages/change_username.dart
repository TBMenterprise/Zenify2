import 'package:flutter/material.dart';

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newUsernameController = TextEditingController();
  String _errorMessage = '';

  void _updateUsername() {
    if (_formKey.currentState!.validate()) {
      // Implementation for updating username
      // This is a placeholder - actual implementation would depend on your app's logic
      setState(() {
        _errorMessage = ''; // Clear any previous errors
      });
      
      // Example: Show success and pop
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username updated successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Username'),
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
                    cursorColor: const Color(0xFF2D2D2D),
                    style: const TextStyle(
                      fontFamily: 'HelveticaNeue',
                      fontSize: 16,
                      color: Color(0xFF2D2D2D),
                    ),
                    decoration: InputDecoration(
                      hintText: 'New Username',
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
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 0,
                    ),
                    child: const Text(
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
    );
  }
}