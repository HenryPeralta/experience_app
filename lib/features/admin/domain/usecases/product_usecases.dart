import '../../../ecommerce/domain/entities/product.dart';
import '../repositories/admin_product_repository.dart';

class CreateProduct {
  final AdminProductRepository repository;

  CreateProduct({required this.repository});

  Future<void> call(Product product) async {
    return await repository.createProduct(product);
  }
}

class UpdateProduct {
  final AdminProductRepository repository;

  UpdateProduct({required this.repository});

  Future<void> call(Product product) async {
    return await repository.updateProduct(product);
  }
}

class DeleteProduct {
  final AdminProductRepository repository;

  DeleteProduct({required this.repository});

  Future<void> call(String productId) async {
    return await repository.deleteProduct(productId);
  }
}

class GetAdminProducts {
  final AdminProductRepository repository;

  GetAdminProducts({required this.repository});

  Future<List<Product>> call(String adminId) async {
    return await repository.getAdminProducts(adminId);
  }
}
