import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_auth_data_source.dart';
import '../../data/datasources/firestore_user_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource(
    ref.read(firebaseAuthProvider),
  );
});

final firestoreUserDataSourceProvider = Provider<FirestoreUserDataSource>((ref) {
  return FirestoreUserDataSource(
    ref.read(firebaseFirestoreProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.read(authDataSourceProvider),
    ref.read(firestoreUserDataSourceProvider),
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

// Provider para acceder al usuario actual con AsyncValue
final currentUserAsyncProvider = FutureProvider<UserEntity?>((ref) async {
  return await ref.read(currentUserProvider).call();
});

// Provider para acceder al rol del usuario actual
final userRoleProvider = FutureProvider<UserRole?>((ref) async {
  final user = await ref.read(currentUserAsyncProvider.future);
  return user?.role;
});

// Provider para verificar si el usuario es admin
final isAdminProvider = FutureProvider<bool>((ref) async {
  final role = await ref.read(userRoleProvider.future);
  return role == UserRole.admin;
});