import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
  });

  factory UserModel.fromFirebase({
    required String uid,
    required String email,
  }) {
    return UserModel(
      uid: uid,
      email: email,
    );
  }
}