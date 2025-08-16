import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountChooserDialog extends StatelessWidget {
  final GoogleSignInAccount account;
  final VoidCallback onAccountSelected;
  final VoidCallback onNewAccount;

  const AccountChooserDialog({
    Key? key,
    required this.account,
    required this.onAccountSelected,
    required this.onNewAccount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose an account',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton(
                onPressed: onAccountSelected,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF2D2D2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: account.photoUrl != null ? NetworkImage(account.photoUrl!) : null,
                      child: account.photoUrl == null ? const Icon(Icons.person) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            account.displayName ?? 'No name',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            account.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: onNewAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 64, 137, 226),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Use another account'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
