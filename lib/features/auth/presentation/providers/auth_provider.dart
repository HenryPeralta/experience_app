import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user_entity.dart';
import 'dependency_injection.dart';

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this.ref) : super(const AuthState());

  final Ref ref;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final user = await ref.read(loginUserProvider).call(
            email: email,
            password: password,
          );

      state = AuthState(
        isLoading: false,
        user: user,
      );
    } catch (e) {
      state = AuthState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await ref.read(logoutUserProvider).call();

    state = const AuthState();
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});