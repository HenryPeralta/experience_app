import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';

abstract class CartDataSource {
  /// Get all items in the cart from local storage
  Future<List<CartItem>> getCartItems();

  /// Add a product to the cart in local storage
  Future<void> addToCart(CartItem cartItem);

  /// Remove an item from the cart in local storage
  Future<void> removeFromCart(CartItem cartItem);

  /// Update the quantity of a cart item in local storage
  Future<void> updateQuantity(CartItem cartItem, int newQuantity);

  /// Clear the entire cart from local storage
  Future<void> clearCart();
}
