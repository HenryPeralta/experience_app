import 'package:experience_app/features/ecommerce/domain/entities/product.dart';

/// ProductModel is a Data Transfer Object (DTO) for Product entity
/// Used to convert between domain layer and API/database responses
class ProductModel {
  final String id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  final List<String> sizes;
  final List<String> colors;

  const ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.sizes,
    required this.colors,
  });

  /// Convert ProductModel (DTO) to Product (entity)
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      image: image,
      category: category,
      description: description,
      sizes: sizes,
      colors: colors,
    );
  }

  /// Convert Product (entity) to ProductModel (DTO)
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      title: product.title,
      price: product.price,
      image: product.image,
      category: product.category,
      description: product.description,
      sizes: product.sizes,
      colors: product.colors,
    );
  }
}
