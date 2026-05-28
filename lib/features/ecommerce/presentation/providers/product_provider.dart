import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/data/models/product_model.dart';

final productProvider = Provider<List<ProductModel>>((ref) {
  return [
    ProductModel(
      id: '1',
      title: 'Amazing T-shirt',
      price: 12.00,
      image: 'assets/onboarding.png',
      category: 'Perfect for you',
      description: 'The perfect t-shirt for when you want to feel comfortable but still stylish. Amazing for all occasions. Made of 100% cotton fabric in four colours. Its modern style gives a lighter look to the outfit. Perfect for the warmest days.',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['#1a1a1a', '#808080', '#c0c0c0', '#e8e8e8'],
    ),
    ProductModel(
      id: '2',
      title: 'Fabulous Pants',
      price: 15.00,
      image: 'assets/onboarding.png',
      category: 'Perfect for you',
      description: 'Comfortable and stylish pants that go with everything. Perfect for casual or business meetings. Made with premium quality material for durability and comfort.',
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      colors: ['#1a1a1a', '#0066cc', '#ff6b6b', '#ffd93d'],
    ),
    ProductModel(
      id: '3',
      title: 'Summer Dress',
      price: 25.00,
      image: 'assets/onboarding.png',
      category: 'For this summer',
      description: 'Light and breathable summer dress perfect for hot days. Features elegant design with comfortable fit.',
      sizes: ['XS', 'S', 'M', 'L'],
      colors: ['#ff69b4', '#ffc0cb', '#ffe4e1', '#fff0f5'],
    ),
    ProductModel(
      id: '4',
      title: 'Beach Shorts',
      price: 18.00,
      image: 'assets/onboarding.png',
      category: 'For this summer',
      description: 'Perfect for beach days. Quick-drying material with comfortable fit.',
      sizes: ['S', 'M', 'L', 'XL'],
      colors: ['#1e90ff', '#87ceeb', '#00ced1', '#00bfff'],
    ),
  ];
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'Perfect for you');

final selectedSizeProvider = StateProvider<String?>((ref) => null);
final selectedColorProvider = StateProvider<String?>((ref) => null);
final cartItemsProvider = StateProvider<List<String>>((ref) => []);
