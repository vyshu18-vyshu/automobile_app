import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple singleton service to manage user state.
/// Extracts first name from email for display purposes.
class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  static UserService get instance => _instance;
  
  UserService._internal();

  String _userName = "User";
  String _userEmail = "user@email.com";
  bool _isLoggedIn = false;

  String get userName => _userName;
  String get userEmail => _userEmail;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _userName = prefs.getString('user_name') ?? "User";
    _userEmail = prefs.getString('user_email') ?? "user@email.com";
  }

  Future<void> setUser(String name, String email) async {
    _userName = name;
    _userEmail = email;
    _isLoggedIn = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
  }

  Future<void> setFromEmail(String email) async {
    final name = email.split('@')[0];
    await setUser(name, email);
  }

  Future<void> setGuest() async {
    _userName = 'Guest';
    _userEmail = 'guest@app.local';
    _isLoggedIn = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_name', 'Guest');
    await prefs.setString('user_email', 'guest@app.local');
  }

  Future<void> clear() async {
    _userName = 'Guest';
    _userEmail = '';
    _isLoggedIn = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('user_name');
    await prefs.remove('user_email');
  }
}
