import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';
import '../datasources/firestore_user_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;
  final FirestoreUserDataSource firestoreDataSource;

  AuthRepositoryImpl(this.dataSource, this.firestoreDataSource);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final credential = await dataSource.login(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('User not found');
    }

    // Obtener datos del usuario desde Firestore
    final userData = await firestoreDataSource.getUserData(user.uid);

    // El usuario debe existir en Firestore
    if (userData == null || userData.isEmpty) {
      throw Exception('Usuario no autorizado. Contacta al administrador.');
    }

    return UserModel.fromFirebaseAndFirestore(
      uid: user.uid,
      email: user.email ?? '',
      userData: userData,
    );
  }

  @override
  Future<void> logout() async {
    await dataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = dataSource.getCurrentUser();

    if (user == null) {
      return null;
    }

    // Obtener datos del usuario desde Firestore
    final userData = await firestoreDataSource.getUserData(user.uid);

    return UserModel.fromFirebaseAndFirestore(
      uid: user.uid,
      email: user.email ?? '',
      userData: userData,
    );
  }
}