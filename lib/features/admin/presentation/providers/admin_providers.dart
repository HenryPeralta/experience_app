import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';

import '../../../ecommerce/domain/entities/product.dart';
import '../../data/datasources/firestore_product_data_source.dart';
import '../../data/repositories/admin_product_repository_impl.dart';
import '../../domain/repositories/admin_product_repository.dart';
import '../../domain/usecases/product_usecases.dart';

// Datasources
final firestoreProductDataSourceProvider = Provider<FirestoreProductDataSource>((ref) {
  return FirestoreProductDataSourceImpl(firestore: FirebaseFirestore.instance);
});

// Repositories
final adminProductRepositoryProvider = Provider<AdminProductRepository>((ref) {
  final dataSource = ref.watch(firestoreProductDataSourceProvider);
  return AdminProductRepositoryImpl(dataSource: dataSource);
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

final getAdminProductsProvider = FutureProvider.family<List<Product>, String>((ref, adminId) async {
  final useCase = ref.watch(GetAdminProductsProvider);
  return await useCase(adminId);
});

// Provider para el use case
final GetAdminProductsProvider = Provider<GetAdminProducts>((ref) {
  final repository = ref.watch(adminProductRepositoryProvider);
  return GetAdminProducts(repository: repository);
});
