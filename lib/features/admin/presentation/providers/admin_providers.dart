import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../ecommerce/domain/entities/product.dart';
import '../../data/datasources/firestore_product_data_source.dart';
import '../../data/datasources/firebase_storage_data_source.dart';
import '../../data/repositories/admin_product_repository_impl.dart';
import '../../data/repositories/admin_storage_repository.dart';
import '../../domain/repositories/admin_product_repository.dart';
import '../../domain/usecases/product_usecases.dart';
import '../../domain/usecases/upload_product_image_use_case.dart';

// Datasources
final firestoreProductDataSourceProvider = Provider<FirestoreProductDataSource>((ref) {
  return FirestoreProductDataSourceImpl(firestore: FirebaseFirestore.instance);
});

final firebaseStorageDataSourceProvider = Provider<FirebaseStorageDataSource>((ref) {
  return FirebaseStorageDataSourceImpl(firebaseStorage: FirebaseStorage.instance);
});

// Repositories
final adminProductRepositoryProvider = Provider<AdminProductRepository>((ref) {
  final dataSource = ref.watch(firestoreProductDataSourceProvider);
  return AdminProductRepositoryImpl(dataSource: dataSource);
});

final adminStorageRepositoryProvider = Provider<AdminStorageRepository>((ref) {
  final dataSource = ref.watch(firebaseStorageDataSourceProvider);
  return AdminStorageRepositoryImpl(firebaseStorageDataSource: dataSource);
});

// Use Cases
final createProductProvider = Provider<CreateProduct>((ref) {
  final repository = ref.watch(adminProductRepositoryProvider);
  return CreateProduct(repository: repository);
});

final updateProductProvider = Provider<UpdateProduct>((ref) {
  final repository = ref.watch(adminProductRepositoryProvider);
  return UpdateProduct(repository: repository);
});

final deleteProductProvider = Provider<DeleteProduct>((ref) {
  final repository = ref.watch(adminProductRepositoryProvider);
  return DeleteProduct(repository: repository);
});

final uploadProductImageProvider = Provider<UploadProductImageUseCase>((ref) {
  final repository = ref.watch(adminStorageRepositoryProvider);
  return UploadProductImageUseCaseImpl(repository: repository);
});

final getAdminProductsProvider = FutureProvider.family<List<Product>, String>((ref, adminId) async {
  final useCase = ref.watch(GetAdminProductsProvider);
  return await useCase(adminId);
});

// Provider para el use case
final GetAdminProductsProvider = Provider<GetAdminProducts>((ref) {
  final repository = ref.watch(adminProductRepositoryProvider);
  return GetAdminProducts(repository: repository);
});

// Provider específico para obtener productos de Firestore en el admin
final adminAllProductsProvider = FutureProvider<List<Product>>((ref) async {
  final useCase = ref.watch(GetAdminProductsProvider);
  return await useCase(''); // El adminId no se usa en getAdminProducts
});
