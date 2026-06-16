import 'product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String selectedSize;
  final String selectedColor;

  const CartItem({
    required this.product,
    required this.quantity,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          selectedSize == other.selectedSize &&
          selectedColor == other.selectedColor;

  @override
  int get hashCode =>
      product.hashCode ^ selectedSize.hashCode ^ selectedColor.hashCode;
}
