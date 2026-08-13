import 'package:cloud_firestore/cloud_firestore.dart' as fb;
import 'package:experience_app/features/ecommerce/domain/entities/order.dart';

abstract class OrderDataSource {
  Future<void> createOrder(PurchaseOrder order);
  Future<PurchaseOrder?> getOrderById(String orderId);
  Future<List<PurchaseOrder>> getUserOrders(String userId);
}

class OrderDataSourceImpl implements OrderDataSource {
  final fb.FirebaseFirestore _firestore;

  OrderDataSourceImpl({required fb.FirebaseFirestore firestore})
      : _firestore = firestore;

  @override
  Future<void> createOrder(PurchaseOrder order) async {
    try {
      await _firestore
          .collection('orders')
          .doc(order.id)
          .set(order.toMap());
      
      print('✅ Order created: ${order.id}');
    } catch (e) {
      print('❌ Error creating order: $e');
      rethrow;
    }
  }

  @override
  Future<PurchaseOrder?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      
      if (doc.exists) {
        return PurchaseOrder.fromMap(doc.data()!);
      }
      
      return null;
    } catch (e) {
      print('❌ Error getting order: $e');
      rethrow;
    }
  }

  @override
  Future<List<PurchaseOrder>> getUserOrders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => PurchaseOrder.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('❌ Error getting user orders: $e');
      rethrow;
    }
  }
}
