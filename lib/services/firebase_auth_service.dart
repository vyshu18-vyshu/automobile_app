import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Firebase Authentication Service
/// Handles all auth operations: sign in, sign up, sign out
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Sign in error: ${e.code} - ${e.message}');
      }
      rethrow;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Sign up error: ${e.code} - ${e.message}');
      }
      rethrow;
    }
  }

  // DEVELOPMENT MODE: Allow any email/password to work
  // This is the permissive mode we used when building the project
  // Firebase is completely bypassed for desktop development
  Future<UserCredential?> signInOrRegister(
    String email,
    String password,
  ) async {
    if (kDebugMode) {
      print('🔓 DEVELOPMENT MODE: Allowing login with any credentials');
      print('Email: $email');
      // Always return null to signal bypass mode success
      return null;
    }
    
    // In production, use Firebase (but we're in development)
    try {
      // Try to sign in first
      return await signInWithEmailPassword(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Account doesn't exist, create it automatically
        if (kDebugMode) {
          print('Auto-registering new user: $email');
        }
        return await signUpWithEmailPassword(email, password);
      }
      // Re-throw other errors (wrong-password, invalid-email, etc.)
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user-friendly error message
  String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
