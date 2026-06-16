import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';
import 'cart_data_source.dart';

class LocalCartDataSource implements CartDataSource {
  // Simulated local storage
  final List<CartItem> _cartItems = [];

  @override
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _cartItems;
  }

  @override
  Future<void> addToCart(CartItem cartItem) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final existingItemIndex = _cartItems.indexWhere(
      (item) =>
          item.product.id == cartItem.product.id &&
          item.selectedSize == cartItem.selectedSize &&
          item.selectedColor == cartItem.selectedColor,
    );

    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex] = _cartItems[existingItemIndex].copyWith(
        quantity: _cartItems[existingItemIndex].quantity + cartItem.quantity,
      );
    } else {
      _cartItems.add(cartItem);
    }
  }

  @override
  Future<void> removeFromCart(CartItem cartItem) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cartItems.removeWhere((item) => item == cartItem);
  }

  @override
  Future<void> updateQuantity(CartItem cartItem, int newQuantity) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    if (newQuantity <= 0) {
      await removeFromCart(cartItem);
      return;
    }

    final itemIndex = _cartItems.indexOf(cartItem);
    if (itemIndex != -1) {
      _cartItems[itemIndex] = cartItem.copyWith(quantity: newQuantity);
    }
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _cartItems.clear();
  }
}
