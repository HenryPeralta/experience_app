class Product {
  final String id;
  final String title;
  final double price;
  final String image;
  final String category;
  final String description;
  final List<String> sizes;
  final List<String> colors;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.category,
    required this.description,
    required this.sizes,
    required this.colors,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ price.hashCode;
}
