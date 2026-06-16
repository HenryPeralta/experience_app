import 'package:experience_app/features/ecommerce/domain/entities/product.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  Future<List<Product>> call(String category) async {
    return await repository.getProductsByCategory(category);
  }
}
