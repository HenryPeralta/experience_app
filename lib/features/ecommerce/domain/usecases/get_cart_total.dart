import 'package:experience_app/features/ecommerce/domain/repositories/cart_repository.dart';

class GetCartTotal {
  final CartRepository repository;

  GetCartTotal(this.repository);

  Future<double> call() async {
    return await repository.getCartTotal();
  }
}
