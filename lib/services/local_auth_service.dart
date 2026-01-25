import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Local Authentication Service
/// Stores user credentials locally without requiring Firebase setup
/// Perfect for development and testing
class LocalAuthService {
  static const String _usersKey = 'local_users';
  static const String _currentUserKey = 'current_user_email';

  /// Sign in with email and password
  /// Auto-creates account if it doesn't exist
  Future<LocalAuthResult> signInOrRegister(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return LocalAuthResult(
        success: false,
        error: 'Please enter both email and password',
      );
    }

    if (password.length < 6) {
      return LocalAuthResult(
        success: false,
        error: 'Password should be at least 6 characters',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    Map<String, String> users = {};

    if (usersJson != null) {
      users = Map<String, String>.from(json.decode(usersJson));
    }

    // Hash the password for security
    final hashedPassword = _hashPassword(password);

    // Check if user exists
    if (users.containsKey(email)) {
      // Verify password
      if (users[email] == hashedPassword) {
        await prefs.setString(_currentUserKey, email);
        return LocalAuthResult(success: true, email: email);
      } else {
        return LocalAuthResult(
          success: false,
          error: 'Incorrect password',
        );
      }
    } else {
      // Auto-register new user
      users[email] = hashedPassword;
      await prefs.setString(_usersKey, json.encode(users));
      await prefs.setString(_currentUserKey, email);
      return LocalAuthResult(success: true, email: email, isNewUser: true);
    }
  }

  /// Get current logged-in user email
  Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final email = await getCurrentUserEmail();
    return email != null;
  }

  /// Sign out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  /// Hash password using SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Clear all users (for testing)
  Future<void> clearAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
    await prefs.remove(_currentUserKey);
  }
}

/// Result of authentication operation
class LocalAuthResult {
  final bool success;
  final String? email;
  final String? error;
  final bool isNewUser;

  LocalAuthResult({
    required this.success,
    this.email,
    this.error,
    this.isNewUser = false,
  });
}
