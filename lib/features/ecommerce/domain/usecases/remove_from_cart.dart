import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/cart_repository.dart';

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  Future<void> call(CartItem cartItem) async {
    return await repository.removeFromCart(cartItem);
  }
}
