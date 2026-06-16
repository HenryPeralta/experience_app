import 'package:experience_app/features/ecommerce/domain/entities/payment_card.dart';

abstract class PaymentDataSource {
  /// Get all saved payment cards from local storage
  Future<List<PaymentCard>> getPaymentCards();

  /// Process a payment
  Future<bool> processPayment(PaymentCard card, double amount);

  /// Save a new payment card in local storage
  Future<void> savePaymentCard(PaymentCard card);

  /// Delete a payment card from local storage
  Future<void> deletePaymentCard(String cardId);
}
