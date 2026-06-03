import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/data/models/cart_item_model.dart';
import 'package:experience_app/features/ecommerce/data/models/product_model.dart';

class CartNotifier extends StateNotifier<List<CartItemModel>> {
  CartNotifier() : super([]);

  void addToCart(ProductModel product, int quantity, String size, String color) {
    final existingItemIndex = state.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (existingItemIndex != -1) {
      final updatedItems = [...state];
      updatedItems[existingItemIndex] = updatedItems[existingItemIndex].copyWith(
        quantity: updatedItems[existingItemIndex].quantity + quantity,
      );
      state = updatedItems;
    } else {
      state = [
        ...state,
        CartItemModel(
          product: product,
          quantity: quantity,
          selectedSize: size,
          selectedColor: color,
        ),
      ];
    }
  }

  void removeFromCart(CartItemModel item) {
    state = state.where((cartItem) => cartItem != item).toList();
  }

  void updateQuantity(CartItemModel item, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(item);
      return;
    }

    final updatedItems = state.map((cartItem) {
      if (cartItem == item) {
        return cartItem.copyWith(quantity: newQuantity);
      }
      return cartItem;
    }).toList();

    state = updatedItems;
  }

  double getTotal() {
    return state.fold(0.0, (total, item) => total + item.totalPrice);
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItemModel>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold(0.0, (total, item) => total + item.totalPrice);
});
