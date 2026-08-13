import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class SaveDeviceTokenUseCase {
  Future<void> call(String token);
}

class SaveDeviceTokenUseCaseImpl implements SaveDeviceTokenUseCase {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  SaveDeviceTokenUseCaseImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  @override
  Future<void> call(String token) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Guardar el token en /users/{uid}/tokens/{token}
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tokens')
          .doc(token)
          .set({
        'token': token,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': 'android',
      });

      print('✅ Device token saved: $token');
    } catch (e) {
      print('❌ Error saving device token: $e');
      rethrow;
    }
  }
}
