import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_auth_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource(
    ref.read(firebaseAuthProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authDataSourceProvider),
  );
});

final loginUserProvider = Provider<LoginUser>((ref) {
  return LoginUser(
    ref.read(authRepositoryProvider),
  );
});

final logoutUserProvider = Provider<LogoutUser>((ref) {
  return LogoutUser(
    ref.read(authRepositoryProvider),
  );
});

final currentUserProvider = Provider<GetCurrentUser>((ref) {
  return GetCurrentUser(
    ref.read(authRepositoryProvider),
  );
});