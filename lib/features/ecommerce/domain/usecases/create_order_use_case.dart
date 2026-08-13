import 'package:experience_app/features/ecommerce/data/repositories/order_repository.dart';
import 'package:experience_app/features/ecommerce/domain/entities/order.dart';

abstract class CreateOrderUseCase {
  Future<void> call(PurchaseOrder order);
}

class CreateOrderUseCaseImpl implements CreateOrderUseCase {
  final OrderRepository _repository;

  CreateOrderUseCaseImpl({required OrderRepository repository})
      : _repository = repository;

  @override
  Future<void> call(PurchaseOrder order) => _repository.createOrder(order);
}
