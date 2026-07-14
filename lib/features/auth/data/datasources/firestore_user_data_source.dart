import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserDataSource {
  final FirebaseFirestore firebaseFirestore;

  FirestoreUserDataSource(this.firebaseFirestore);

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get();
      return doc.data();
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }

  Future<void> saveUserData({
    required String uid,
    required String email,
    required String role,
  }) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(uid)
          .set({
            'uid': uid,
            'email': email,
            'role': role,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error saving user data: $e');
    }
  }

  Future<void> updateUserRole({
    required String uid,
    required String role,
  }) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(uid)
          .update({'role': role});
    } catch (e) {
      throw Exception('Error updating user role: $e');
    }
  }
}
