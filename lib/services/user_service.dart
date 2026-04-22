// User Service
// Handles user data management
// Provides methods for updating user profile
// Fetches user statistics and activity history
// Manages user preferences

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  /// Create new user profile in Firestore
  Future<void> createUserProfile(User firebaseUser, {String? displayName}) async {
    try {
      final appUser = AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: displayName ?? firebaseUser.displayName ?? 'User',
        photoURL: firebaseUser.photoURL,
        createdAt: DateTime.now(),
      );

      await _usersCollection.doc(firebaseUser.uid).set(appUser.toMap());
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Get user profile from Firestore
  Future<AppUser?> getUserProfile(String uid) async {
    try {
      final doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Get current user profile
  Future<AppUser?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return getUserProfile(user.uid);
  }

  /// Update user profile
  Future<void> updateUserProfile(String uid, {
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (displayName != null) updateData['displayName'] = displayName;
      if (photoURL != null) updateData['photoURL'] = photoURL;

      await _usersCollection.doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Update user stats (called when pacts change)
  Future<void> updateUserStats(String uid, {
    double? totalContributed,
    int? activePacts,
    int? completedPacts,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };

      if (totalContributed != null) updateData['totalContributed'] = totalContributed;
      if (activePacts != null) updateData['activePacts'] = activePacts;
      if (completedPacts != null) updateData['completedPacts'] = completedPacts;

      await _usersCollection.doc(uid).update(updateData);
    } catch (e) {
      throw Exception('Failed to update user stats: $e');
    }
  }

  /// Stream user profile for real-time updates
  Stream<AppUser?> streamUserProfile(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }
}
