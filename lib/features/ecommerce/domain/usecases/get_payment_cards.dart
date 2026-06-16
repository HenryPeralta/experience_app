import 'package:experience_app/features/ecommerce/domain/entities/payment_card.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/payment_repository.dart';

class GetPaymentCards {
  final PaymentRepository repository;

  GetPaymentCards(this.repository);

  Future<List<PaymentCard>> call() async {
    return await repository.getPaymentCards();
  }
}
