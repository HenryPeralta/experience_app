import 'package:experience_app/features/ecommerce/data/repositories/order_repository.dart';
import 'package:experience_app/features/ecommerce/domain/entities/order.dart';

abstract class GetUserOrdersUseCase {
  Future<List<PurchaseOrder>> call(String userId);
}

class GetUserOrdersUseCaseImpl implements GetUserOrdersUseCase {
  final OrderRepository _repository;

  GetUserOrdersUseCaseImpl({required OrderRepository repository})
      : _repository = repository;

  @override
  Future<List<PurchaseOrder>> call(String userId) => _repository.getUserOrders(userId);
}
