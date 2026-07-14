import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.email,
    super.role = UserRole.customer,
    super.createdAt,
  });

  factory UserModel.fromFirebase({
    required String uid,
    required String email,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      role: UserRole.customer,
    );
  }

  factory UserModel.fromFirebaseAndFirestore({
    required String uid,
    required String email,
    required Map<String, dynamic>? userData,
  }) {
    final roleString = userData?['role'] as String? ?? 'user';
    final role = roleString == 'admin' ? UserRole.admin : UserRole.customer;
    
    DateTime? createdAt;
    try {
      final createdAtField = userData?['createdAt'];
      if (createdAtField is Timestamp) {
        createdAt = createdAtField.toDate();
      } else if (createdAtField is String) {
        createdAt = DateTime.parse(createdAtField);
      }
    } catch (_) {
      createdAt = null;
    }
    
    return UserModel(
      uid: uid,
      email: email,
      role: role,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role == UserRole.admin ? 'admin' : 'user',
      'createdAt': createdAt,
    };
  }
}