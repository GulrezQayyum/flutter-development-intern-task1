import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserFirestoreService {
  static final CollectionReference<Map<String, dynamic>> _users =
  FirebaseFirestore.instance.collection('users');

  // Save (or update) the signed-in user's name and email in Firestore
  static Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      await _users.doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  // Fetch the user's profile once
  static Future<AppUser?> getUserProfile(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (!doc.exists || doc.data() == null) return null;
      return AppUser.fromMap(doc.data()!, uid);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Listen for real-time updates to the user's profile
  static Stream<AppUser?> streamUserProfile(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return AppUser.fromMap(doc.data()!, uid);
    });
  }
}