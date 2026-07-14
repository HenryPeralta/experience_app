import '../../../ecommerce/domain/entities/product.dart';

abstract class AdminProductRepository {
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<Product> getProduct(String productId);
  Future<List<Product>> getAdminProducts(String adminId);
}
