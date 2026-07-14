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

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      sizes: List<String>.from(map['sizes'] as List? ?? []),
      colors: List<String>.from(map['colors'] as List? ?? []),
    );
  }

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
