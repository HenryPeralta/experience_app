import 'package:experience_app/features/ecommerce/domain/entities/cart_item.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/cart_repository.dart';
import 'package:experience_app/features/ecommerce/data/datasources/cart_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartDataSource dataSource;

  CartRepositoryImpl({required this.dataSource});

  @override
  Future<List<CartItem>> getCartItems() async {
    try {
      return await dataSource.getCartItems();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addToCart(CartItem cartItem) async {
    try {
      return await dataSource.addToCart(cartItem);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromCart(CartItem cartItem) async {
    try {
      return await dataSource.removeFromCart(cartItem);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateQuantity(CartItem cartItem, int newQuantity) async {
    try {
      return await dataSource.updateQuantity(cartItem, newQuantity);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      return await dataSource.clearCart();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<double> getCartTotal() async {
    try {
      final items = await dataSource.getCartItems();
      return items.fold<double>(0.0, (total, item) => total + item.totalPrice);
    } catch (e) {
      rethrow;
    }
  }
}
