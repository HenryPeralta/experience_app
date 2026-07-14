enum UserRole { admin, customer }

class UserEntity {
  final String uid;
  final String email;
  final UserRole role;
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    this.role = UserRole.customer,
    this.createdAt,
  });
}