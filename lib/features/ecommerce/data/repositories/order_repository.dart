import 'package:experience_app/features/ecommerce/data/datasources/order_data_source.dart';
import 'package:experience_app/features/ecommerce/domain/entities/order.dart';

abstract class OrderRepository {
  Future<void> createOrder(PurchaseOrder order);
  Future<PurchaseOrder?> getOrderById(String orderId);
  Future<List<PurchaseOrder>> getUserOrders(String userId);
}

class OrderRepositoryImpl implements OrderRepository {
  final OrderDataSource _dataSource;

  OrderRepositoryImpl({required OrderDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<void> createOrder(PurchaseOrder order) => _dataSource.createOrder(order);

  @override
  Future<PurchaseOrder?> getOrderById(String orderId) =>
      _dataSource.getOrderById(orderId);

  @override
  Future<List<PurchaseOrder>> getUserOrders(String userId) =>
      _dataSource.getUserOrders(userId);
}
