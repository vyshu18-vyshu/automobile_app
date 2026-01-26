import 'package:cloud_firestore/cloud_firestore.dart';

/// User Profile Model
/// Represents user data stored in Firestore
class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime lastSignIn;

  UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.lastSignIn,
  });

  /// Create UserModel from email (for new signups)
  factory UserModel.fromEmail(String userId, String email) {
    final now = DateTime.now();
    final displayName = email.split('@')[0]; // Extract name from email
    
    return UserModel(
      userId: userId,
      email: email,
      displayName: displayName,
      createdAt: now,
      lastSignIn: now,
    );
  }

  /// Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSignIn': Timestamp.fromDate(lastSignIn),
    };
  }

  /// Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      email: map['email'] as String,
      displayName: map['displayName'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastSignIn: (map['lastSignIn'] as Timestamp).toDate(),
    );
  }

  /// Create copy with updated fields
  UserModel copyWith({
    String? userId,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastSignIn,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastSignIn: lastSignIn ?? this.lastSignIn,
    );
  }
}
