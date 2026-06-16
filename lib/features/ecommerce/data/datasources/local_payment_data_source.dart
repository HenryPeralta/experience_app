import 'package:experience_app/features/ecommerce/domain/entities/payment_card.dart';
import 'payment_data_source.dart';

class LocalPaymentDataSource implements PaymentDataSource {
  // Simulated local storage
  final List<PaymentCard> _paymentCards = [
    const PaymentCard(
      id: '1',
      type: 'mastercard',
      cardNumber: 'xxxx xxxx xxxx 1234',
      cardHolder: 'Mastercard',
      expiryDate: '12/25',
      cvv: '123',
    ),
    const PaymentCard(
      id: '2',
      type: 'visa',
      cardNumber: 'xxxx xxxx xxxx 9876',
      cardHolder: 'Visa',
      expiryDate: '11/24',
      cvv: '456',
    ),
  ];

  @override
  Future<List<PaymentCard>> getPaymentCards() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _paymentCards;
  }

  @override
  Future<bool> processPayment(PaymentCard card, double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate payment processing - always successful in this mock
    return true;
  }

  @override
  Future<void> savePaymentCard(PaymentCard card) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _paymentCards.add(card);
  }

  @override
  Future<void> deletePaymentCard(String cardId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _paymentCards.removeWhere((card) => card.id == cardId);
  }
}
