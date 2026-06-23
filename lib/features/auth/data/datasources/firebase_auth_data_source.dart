import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthDataSource(this.firebaseAuth);

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}