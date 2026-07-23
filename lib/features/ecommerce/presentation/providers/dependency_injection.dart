import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:experience_app/features/ecommerce/data/datasources/cart_data_source.dart';
import 'package:experience_app/features/ecommerce/data/datasources/local_cart_data_source.dart';
import 'package:experience_app/features/ecommerce/data/datasources/local_payment_data_source.dart';
import 'package:experience_app/features/ecommerce/data/datasources/payment_data_source.dart';
import 'package:experience_app/features/ecommerce/data/datasources/product_data_source.dart';
import 'package:experience_app/features/ecommerce/data/datasources/firestore_product_data_source_adapter.dart';
import 'package:experience_app/features/ecommerce/data/repositories/cart_repository_impl.dart';
import 'package:experience_app/features/ecommerce/data/repositories/payment_repository_impl.dart';
import 'package:experience_app/features/ecommerce/data/repositories/product_repository_impl.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/cart_repository.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/payment_repository.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/product_repository.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/add_to_cart.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/clear_cart.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_all_products.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_cart_items.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_cart_total.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_payment_cards.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_products_by_category.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/process_payment.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/remove_from_cart.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/update_cart_quantity.dart';

// ========== DataSources ==========
final productDataSourceProvider = Provider<ProductDataSource>((ref) {
  return FirestoreProductDataSourceAdapter(firestore: FirebaseFirestore.instance);
});

final cartDataSourceProvider = Provider<CartDataSource>((ref) {
  return LocalCartDataSource();
});

final paymentDataSourceProvider = Provider<PaymentDataSource>((ref) {
  return LocalPaymentDataSource();
});

// ========== Repositories ==========
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(productDataSourceProvider);
  return ProductRepositoryImpl(dataSource: dataSource);
});

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dataSource = ref.watch(cartDataSourceProvider);
  return CartRepositoryImpl(dataSource: dataSource);
});

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final dataSource = ref.watch(paymentDataSourceProvider);
  return PaymentRepositoryImpl(dataSource: dataSource);
});

// ========== UseCases ==========
final getAllProductsProvider = Provider<GetAllProducts>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetAllProducts(repository);
});

final getProductsByCategoryProvider = Provider<GetProductsByCategory>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsByCategory(repository);
});

final getCartItemsProvider = Provider<GetCartItems>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return GetCartItems(repository);
});

final addToCartProvider = Provider<AddToCart>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return AddToCart(repository);
});

final removeFromCartProvider = Provider<RemoveFromCart>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return RemoveFromCart(repository);
});

final updateCartQuantityProvider = Provider<UpdateCartQuantity>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return UpdateCartQuantity(repository);
});

final getCartTotalProvider = Provider<GetCartTotal>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return GetCartTotal(repository);
});

final clearCartProvider = Provider<ClearCart>((ref) {
  final repository = ref.watch(cartRepositoryProvider);
  return ClearCart(repository);
});

final getPaymentCardsProvider = Provider<GetPaymentCards>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return GetPaymentCards(repository);
});

final processPaymentProvider = Provider<ProcessPayment>((ref) {
  final repository = ref.watch(paymentRepositoryProvider);
  return ProcessPayment(repository);
});
