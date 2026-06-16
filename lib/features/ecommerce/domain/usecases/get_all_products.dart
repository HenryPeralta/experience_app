import 'package:experience_app/features/ecommerce/domain/entities/product.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/product_repository.dart';

class GetAllProducts {
  final ProductRepository repository;

  GetAllProducts(this.repository);

  Future<List<Product>> call() async {
    return await repository.getAllProducts();
  }
}
