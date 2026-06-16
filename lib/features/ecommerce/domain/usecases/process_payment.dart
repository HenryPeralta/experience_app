import 'package:experience_app/features/ecommerce/domain/entities/payment_card.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/payment_repository.dart';

class ProcessPayment {
  final PaymentRepository repository;

  ProcessPayment(this.repository);

  Future<bool> call(PaymentCard card, double amount) async {
    return await repository.processPayment(card, amount);
  }
}
