import 'package:experience_app/features/ecommerce/domain/entities/payment_card.dart';
import 'package:experience_app/features/ecommerce/domain/repositories/payment_repository.dart';
import 'package:experience_app/features/ecommerce/data/datasources/payment_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentDataSource dataSource;

  PaymentRepositoryImpl({required this.dataSource});

  @override
  Future<List<PaymentCard>> getPaymentCards() async {
    try {
      return await dataSource.getPaymentCards();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> processPayment(PaymentCard card, double amount) async {
    try {
      return await dataSource.processPayment(card, amount);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> savePaymentCard(PaymentCard card) async {
    try {
      return await dataSource.savePaymentCard(card);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePaymentCard(String cardId) async {
    try {
      return await dataSource.deletePaymentCard(cardId);
    } catch (e) {
      rethrow;
    }
  }
}
