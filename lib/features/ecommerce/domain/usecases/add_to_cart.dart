import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  Future<void> call(CartItem cartItem) async {
    return await repository.addToCart(cartItem);
  }
}
