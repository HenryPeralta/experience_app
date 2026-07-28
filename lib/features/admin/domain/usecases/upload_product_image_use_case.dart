import 'dart:io';
import '../../data/repositories/admin_storage_repository.dart';

abstract class UploadProductImageUseCase {
  Future<String> call(File imageFile, String productId);
}

class UploadProductImageUseCaseImpl implements UploadProductImageUseCase {
  final AdminStorageRepository repository;

  UploadProductImageUseCaseImpl({required this.repository});

  @override
  Future<String> call(File imageFile, String productId) async {
    return await repository.uploadProductImage(imageFile, productId);
  }
}
