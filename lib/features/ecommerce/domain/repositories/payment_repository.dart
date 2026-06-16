import 'package:experience_app/features/ecommerce/domain/entities/payment_card.dart';

abstract class PaymentRepository {
  /// Get all saved payment cards
  Future<List<PaymentCard>> getPaymentCards();

  /// Process a payment
  Future<bool> processPayment(PaymentCard card, double amount);

  /// Save a new payment card
  Future<void> savePaymentCard(PaymentCard card);

  /// Delete a payment card
  Future<void> deletePaymentCard(String cardId);
}
