import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/domain/entities/product.dart';
import 'dependency_injection.dart';

// State providers for UI
final selectedCategoryProvider = StateProvider<String>((ref) => 'Perfect for you');

final selectedSizeProvider = StateProvider<String?>((ref) => null);
final selectedColorProvider = StateProvider<String?>((ref) => null);

// Products list provider - FutureProvider for async loading
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final useCase = ref.watch(getAllProductsProvider);
  return await useCase();
});

// Products by category provider
final productsByCategoryProvider = FutureProvider<List<Product>>((ref) async {
  final useCase = ref.watch(getProductsByCategoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  return await useCase(category);
});
