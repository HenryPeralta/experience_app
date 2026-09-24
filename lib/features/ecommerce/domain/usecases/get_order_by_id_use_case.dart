import 'package:experience_app/features/ecommerce/data/repositories/order_repository.dart';
import 'package:experience_app/features/ecommerce/domain/entities/order.dart';

abstract class GetOrderByIdUseCase {
  Future<PurchaseOrder?> call(String orderId);
}

class GetOrderByIdUseCaseImpl implements GetOrderByIdUseCase {
  final OrderRepository _repository;

  GetOrderByIdUseCaseImpl({required OrderRepository repository})
      : _repository = repository;

  @override
  Future<PurchaseOrder?> call(String orderId) => _repository.getOrderById(orderId);
}
