import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';

abstract class CartRepository {
  /// Get all items in the cart
  Future<List<CartItem>> getCartItems();

  /// Add a product to the cart
  Future<void> addToCart(CartItem cartItem);

  /// Remove an item from the cart
  Future<void> removeFromCart(CartItem cartItem);

  /// Update the quantity of a cart item
  Future<void> updateQuantity(CartItem cartItem, int newQuantity);

  /// Clear the entire cart
  Future<void> clearCart();

  /// Get the total price of the cart
  Future<double> getCartTotal();
}
