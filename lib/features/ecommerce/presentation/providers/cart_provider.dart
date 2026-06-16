import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';
import 'package:experience_app/features/ecommerce/domain/entities/product.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/add_to_cart.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/clear_cart.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_cart_items.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/remove_from_cart.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/update_cart_quantity.dart';
import 'dependency_injection.dart';

// Cart items provider - FutureProvider for async loading
final cartItemsProvider = FutureProvider<List<CartItem>>((ref) async {
  final useCase = ref.watch(getCartItemsProvider);
  return await useCase();
});

// Cart total provider
final cartTotalProvider = FutureProvider<double>((ref) async {
  final useCase = ref.watch(getCartTotalProvider);
  return await useCase();
});

// StateNotifier to handle cart operations
class CartNotifier extends StateNotifier<List<CartItem>> {
  final AddToCart _addToCartUseCase;
  final RemoveFromCart _removeFromCartUseCase;
  final UpdateCartQuantity _updateQuantityUseCase;
  final ClearCart _clearCartUseCase;
  final GetCartItems _getCartItemsUseCase;

  CartNotifier({
    required AddToCart addToCartUseCase,
    required RemoveFromCart removeFromCartUseCase,
    required UpdateCartQuantity updateQuantityUseCase,
    required ClearCart clearCartUseCase,
    required GetCartItems getCartItemsUseCase,
  }) : _addToCartUseCase = addToCartUseCase,
       _removeFromCartUseCase = removeFromCartUseCase,
       _updateQuantityUseCase = updateQuantityUseCase,
       _clearCartUseCase = clearCartUseCase,
       _getCartItemsUseCase = getCartItemsUseCase,
       super([]);

  Future<void> loadCart() async {
    try {
      final items = await _getCartItemsUseCase();
      state = items;
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> addToCart(
    Product product,
    int quantity,
    String size,
    String color,
  ) async {
    try {
      final cartItem = CartItem(
        product: product,
        quantity: quantity,
        selectedSize: size,
        selectedColor: color,
      );

      await _addToCartUseCase(cartItem);

      await loadCart();

      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFromCart(CartItem item) async {
    try {
      await _removeFromCartUseCase(item);
      await loadCart();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateQuantity(CartItem item, int newQuantity) async {
    try {
      await _updateQuantityUseCase(item, newQuantity);

      await loadCart();

      state = [...state];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _clearCartUseCase();
      state = [];
    } catch (e) {
      rethrow;
    }
  }
}

// Cart provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final addToCartUseCase = ref.watch(addToCartProvider);
  final removeFromCartUseCase = ref.watch(removeFromCartProvider);
  final updateQuantityUseCase = ref.watch(updateCartQuantityProvider);
  final clearCartUseCase = ref.watch(clearCartProvider);
  final getCartItemsUseCase = ref.watch(getCartItemsProvider);

  return CartNotifier(
    addToCartUseCase: addToCartUseCase,
    removeFromCartUseCase: removeFromCartUseCase,
    updateQuantityUseCase: updateQuantityUseCase,
    clearCartUseCase: clearCartUseCase,
    getCartItemsUseCase: getCartItemsUseCase,
  );
});
