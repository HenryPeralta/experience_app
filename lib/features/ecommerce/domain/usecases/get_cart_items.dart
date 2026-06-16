import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  Future<List<CartItem>> call() async {
    return await repository.getCartItems();
  }
}
