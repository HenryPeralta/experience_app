class ProductModel {
  final String id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  final List<String> sizes;
  final List<String> colors;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.sizes,
    required this.colors,
  });
}
