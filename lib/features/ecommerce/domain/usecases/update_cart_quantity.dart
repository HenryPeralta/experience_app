import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/cart_repository.dart';

class UpdateCartQuantity {
  final CartRepository repository;

  UpdateCartQuantity(this.repository);

  Future<void> call(CartItem cartItem, int newQuantity) async {
    return await repository.updateQuantity(cartItem, newQuantity);
  }
}
