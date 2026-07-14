import '../../../ecommerce/domain/entities/product.dart';
import '../../domain/repositories/admin_product_repository.dart';
import '../datasources/firestore_product_data_source.dart';

class AdminProductRepositoryImpl implements AdminProductRepository {
  final FirestoreProductDataSource dataSource;

  AdminProductRepositoryImpl({required this.dataSource});

  @override
  Future<void> createProduct(Product product) async {
    await dataSource.createProduct(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    await dataSource.updateProduct(product);
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await dataSource.deleteProduct(productId);
  }

  @override
  Future<Product> getProduct(String productId) async {
    return await dataSource.getProduct(productId);
  }

  @override
  Future<List<Product>> getAdminProducts(String adminId) async {
    return await dataSource.getAdminProducts(adminId);
  }
}
