import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

final ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

/// Service class that handles all authentication-related operations.
/// 
/// This service provides methods for:
/// - Email/password authentication
/// - Google Sign-In
/// - Account management
/// - User profile operations
/// 
/// The service is implemented as a singleton and can be accessed through
/// the global [authService] ValueNotifier.
class AuthService {
  /// Firebase Firestore instance for user data storage
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Firebase Authentication instance for auth operations
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  /// Google Sign-In instance configured for email scope
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    signInOption: SignInOption.standard,
  );

  /// Returns the currently signed-in user or null if no user is signed in
  User? get currentUser => firebaseAuth.currentUser;
  
  /// Stream of authentication state changes.
  /// 
  /// Listen to this stream to be notified when:
  /// - User signs in
  /// - User signs out
  /// - Token refresh occurs
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();



  /// Signs in a user using email and password authentication.
  /// 
  /// Parameters:
  /// - [email] The user's email address
  /// - [password] The user's password
  /// 
  /// Returns:
  /// - [UserCredential] containing the user's authentication information
  /// 
  /// Throws:
  /// - FirebaseAuthException with code 'user-not-found' if email doesn't exist
  /// - FirebaseAuthException with code 'wrong-password' for incorrect password
  /// - Other FirebaseAuthException types for various authentication errors
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

    // Sign out first to always show account picker
    await _googleSignIn.signOut();
      
    // Show Google account picker
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(code: 'canceled', message: 'Sign-in canceled');
    }

    // Get auth tokens
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in with Firebase
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
