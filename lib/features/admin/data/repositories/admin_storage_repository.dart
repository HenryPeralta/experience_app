import 'dart:io';
import '../datasources/firebase_storage_data_source.dart';

abstract class AdminStorageRepository {
  Future<String> uploadProductImage(File imageFile, String productId);
}

class AdminStorageRepositoryImpl implements AdminStorageRepository {
  final FirebaseStorageDataSource firebaseStorageDataSource;

  AdminStorageRepositoryImpl({required this.firebaseStorageDataSource});

  @override
  Future<String> uploadProductImage(File imageFile, String productId) async {
    return await firebaseStorageDataSource.uploadProductImage(imageFile, productId);
  }
}
