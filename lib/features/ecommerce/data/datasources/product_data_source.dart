import 'package:experience_app/features/ecommerce/domain/entities/product.dart';

abstract class ProductDataSource {
  /// Get all available products
  Future<List<Product>> getAllProducts();

  /// Get products by category
  Future<List<Product>> getProductsByCategory(String category);

  /// Get a single product by ID
  Future<Product?> getProductById(String id);
}
