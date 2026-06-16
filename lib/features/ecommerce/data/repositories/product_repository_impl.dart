import 'package:experience_app/features/ecommerce/domain/entities/product.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/product_repository.dart';
import 'package:experience_app/features/ecommerce/data/datasources/product_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl({required this.dataSource});

  @override
  Future<List<Product>> getAllProducts() async {
    try {
      return await dataSource.getAllProducts();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      return await dataSource.getProductsByCategory(category);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      return await dataSource.getProductById(id);
    } catch (e) {
      rethrow;
    }
  }
}
