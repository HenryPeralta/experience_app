import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

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

    return UserModel.fromFirebase(
      uid: user.uid,
      email: user.email ?? '',
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

    return UserModel.fromFirebase(
      uid: user.uid,
      email: user.email ?? '',
    );
  }
}