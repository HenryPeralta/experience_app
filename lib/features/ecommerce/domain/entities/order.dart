class PurchaseOrder {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status; // pending, completed, shipped, delivered
  final DateTime createdAt;
  final String shippingAddress;
  final String paymentMethod;

  PurchaseOrder({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'status': status,
      'createdAt': createdAt,
      'shippingAddress': shippingAddress,
      'paymentMethod': paymentMethod,
    };
  }

  // Create from Map (from Firestore)
  factory PurchaseOrder.fromMap(Map<String, dynamic> map) {
    return PurchaseOrder(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List<dynamic>)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      total: (map['total'] as num).toDouble(),
      status: map['status'] as String,
      createdAt: (map['createdAt'] as dynamic).toDate(),
      shippingAddress: map['shippingAddress'] as String,
      paymentMethod: map['paymentMethod'] as String,
    );
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String size;
  final String color;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.size,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'size': size,
      'color': color,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] as String,
      productName: map['productName'] as String,
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'] as int,
      size: map['size'] as String,
      color: map['color'] as String,
    );
  }
}
