// User Model
// Represents a user in the Pocket Pact application
// Contains user profile data: id, name, email, profile picture, etc.
// Includes methods for JSON serialization/deserialization

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoURL;
  final double totalContributed;
  final int activePacts;
  final int completedPacts;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.totalContributed = 0.0,
    this.activePacts = 0,
    this.completedPacts = 0,
    required this.createdAt,
    this.updatedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'totalContributed': totalContributed,
      'activePacts': activePacts,
      'completedPacts': completedPacts,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Create from Firestore document
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? 'User',
      photoURL: map['photoURL'],
      totalContributed: (map['totalContributed'] ?? 0.0).toDouble(),
      activePacts: map['activePacts'] ?? 0,
      completedPacts: map['completedPacts'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser.fromMap(data);
  }

  // Copy with method for updates
  AppUser copyWith({
    String? displayName,
    String? photoURL,
    double? totalContributed,
    int? activePacts,
    int? completedPacts,
    DateTime? updatedAt,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      totalContributed: totalContributed ?? this.totalContributed,
      activePacts: activePacts ?? this.activePacts,
      completedPacts: completedPacts ?? this.completedPacts,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
