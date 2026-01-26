import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

/// User service with Firebase Firestore integration.
/// Manages user state both locally (SharedPreferences) and in cloud (Firestore).
class UserService {
  // Singleton pattern
  static final UserService _instance = UserService._internal();
  static UserService get instance => _instance;
  
  UserService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _userName = "User";
  String _userEmail = "user@email.com";
  String _userId = "";
  bool _isLoggedIn = false;

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userId => _userId;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _userName = prefs.getString('user_name') ?? "User";
    _userEmail = prefs.getString('user_email') ?? "user@email.com";
    _userId = prefs.getString('user_id') ?? "";
  }

  Future<void> setUser(String name, String email, {String? userId}) async {
    _userName = name;
    _userEmail = email;
    _userId = userId ?? _userId;
    _isLoggedIn = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    if (userId != null) {
      await prefs.setString('user_id', userId);
    }
  }

  Future<void> setFromEmail(String email, {String? userId}) async {
    final name = email.split('@')[0];
    await setUser(name, email, userId: userId);
  }

  /// Create new user profile in Firestore
  /// Call this after successful signup
  Future<void> createUserInFirestore(String email, {String? userId}) async {
    try {
      // Use provided userId or get from current Firebase user
      final uid = userId ?? _auth.currentUser?.uid;
      
      if (uid == null) {
        if (kDebugMode) {
          print('⚠️ No user ID available, skipping Firestore creation (development mode)');
        }
        // In development mode, still save locally
        await setFromEmail(email, userId: 'dev_user');
        return;
      }

      // Create user model
      final userModel = UserModel.fromEmail(uid, email);

      // Save to Firestore
      await _firestore.collection('users').doc(uid).set(userModel.toMap());

      // Update local state
      await setUser(userModel.displayName, userModel.email, userId: uid);

      if (kDebugMode) {
        print('✅ User profile saved to Firestore: $email');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error creating user in Firestore: $e');
      }
      // Still update local state even if Firestore fails
      await setFromEmail(email, userId: userId);
      rethrow;
    }
  }

  /// Fetch user data from Firestore
  /// Call this after successful login
  Future<UserModel?> getUserFromFirestore({String? userId}) async {
    try {
      final uid = userId ?? _auth.currentUser?.uid;
      
      if (uid == null) {
        if (kDebugMode) {
          print('⚠️ No user ID available, cannot fetch from Firestore');
        }
        return null;
      }

      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (!doc.exists) {
        if (kDebugMode) {
          print('⚠️ User document not found in Firestore for UID: $uid');
        }
        return null;
      }

      final userModel = UserModel.fromMap(doc.data()!);
      
      // Update local state
      await setUser(userModel.displayName, userModel.email, userId: uid);

      if (kDebugMode) {
        print('✅ User data loaded from Firestore: ${userModel.email}');
      }

      return userModel;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error fetching user from Firestore: $e');
      }
      return null;
    }
  }

  /// Update last sign-in timestamp
  Future<void> updateLastSignIn({String? userId}) async {
    try {
      final uid = userId ?? _auth.currentUser?.uid ?? _userId;
      
      if (uid.isEmpty || uid == 'dev_user') {
        if (kDebugMode) {
          print('⚠️ Skipping last sign-in update (development mode)');
        }
        return;
      }

      await _firestore.collection('users').doc(uid).update({
        'lastSignIn': Timestamp.now(),
      });

      if (kDebugMode) {
        print('✅ Updated last sign-in timestamp for user: $uid');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating last sign-in: $e');
      }
      // Don't throw - this is not critical
    }
  }

  Future<void> setGuest() async {
    _userName = 'Guest';
    _userEmail = 'guest@app.local';
    _userId = 'guest';
    _isLoggedIn = true;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_name', 'Guest');
    await prefs.setString('user_email', 'guest@app.local');
    await prefs.setString('user_id', 'guest');
  }

  Future<void> clear() async {
    _userName = 'Guest';
    _userEmail = '';
    _userId = '';
    _isLoggedIn = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_id');
  }
}
