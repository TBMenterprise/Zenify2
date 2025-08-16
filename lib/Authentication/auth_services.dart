import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'account_chooser_dialog.dart';

final ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    signInOption: SignInOption.standard,
  );

  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();



  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw FirebaseAuthException(
            code: 'wrong-password',
            message: 'Wrong password provided for that user.');
      }
      rethrow;
    }
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      final GoogleAuthProvider provider = GoogleAuthProvider();
      provider.setCustomParameters({'prompt': 'select_account'});
      return await firebaseAuth.signInWithPopup(provider);
    }

    // Try to get currently signed in account
    GoogleSignInAccount? currentAccount = await _googleSignIn.signInSilently();
    
    // If we have a signed in account, show the chooser
    if (currentAccount != null) {
      // Show account chooser dialog
      final bool useExisting = await showDialog<bool>(
        context: context,
        builder: (context) => AccountChooserDialog(
          account: currentAccount,
          onAccountSelected: () => Navigator.of(context).pop(true),
          onNewAccount: () async {
            await _googleSignIn.signOut(); // Sign out to force new account selection
            Navigator.of(context).pop(false); // Close dialog, trigger new sign in
          },
        ),
      ) ?? false;

      if (useExisting) {
        // User wants to use existing account
        final GoogleSignInAuthentication googleAuth = await currentAccount.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return await firebaseAuth.signInWithCredential(credential);
      }
    }

    // No accounts or user wants new account
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'canceled', message: 'Sign-in canceled');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found for that email.');
      }
      rethrow;
    }
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required int age,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'age': age,
      'email': currentUser!.email,
    });
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}
