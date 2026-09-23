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
      // Usar Firestore Batch para transacción atómica
      final batch = _firestore.batch();
      
      // 1. Crear la orden con timestamp del servidor
      final orderRef = _firestore.collection('orders').doc(order.id);
      final orderData = order.toMap();
      
      // Reemplazar el DateTime local con el timestamp del servidor
      orderData['createdAt'] = fb.FieldValue.serverTimestamp();
      
      batch.set(orderRef, orderData);
      
      // 2. Decrementar inventario para cada producto
      for (final item in order.items) {
        final productRef = _firestore.collection('products').doc(item.productId);
        batch.update(productRef, {
          'quantity': fb.FieldValue.increment(-item.quantity),
        });
      }
      
      // Ejecutar todas las operaciones en una transacción
      await batch.commit();
      
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
