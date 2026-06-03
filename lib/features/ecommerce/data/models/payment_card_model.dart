class PaymentCard {
  final String id;
  final String type; // 'mastercard', 'visa', 'applepay'
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;

  PaymentCard({
    required this.id,
    required this.type,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
  });

  PaymentCard copyWith({
    String? id,
    String? type,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cvv,
  }) {
    return PaymentCard(
      id: id ?? this.id,
      type: type ?? this.type,
      cardNumber: cardNumber ?? this.cardNumber,
      cardHolder: cardHolder ?? this.cardHolder,
      expiryDate: expiryDate ?? this.expiryDate,
      cvv: cvv ?? this.cvv,
    );
  }
}
