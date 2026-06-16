import '../../domain/entities/payment_card.dart';

class CheckoutState {
  final int currentStep; // 0: Your bag, 1: Shipping, 2: Payment, 3: Complete
  final List<PaymentCard> paymentCards;
  final String selectedCardId;
  final String selectedPaymentMethod; // 'credit_card', 'applepay'
  final bool sameBillingAddress;
  final bool isProcessing;
  final bool paymentCompleted;

  const CheckoutState({
    required this.currentStep,
    required this.paymentCards,
    required this.selectedCardId,
    required this.selectedPaymentMethod,
    required this.sameBillingAddress,
    this.isProcessing = false,
    this.paymentCompleted = false,
  });

  CheckoutState copyWith({
    int? currentStep,
    List<PaymentCard>? paymentCards,
    String? selectedCardId,
    String? selectedPaymentMethod,
    bool? sameBillingAddress,
    bool? isProcessing,
    bool? paymentCompleted,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      paymentCards: paymentCards ?? this.paymentCards,
      selectedCardId: selectedCardId ?? this.selectedCardId,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      sameBillingAddress: sameBillingAddress ?? this.sameBillingAddress,
      isProcessing: isProcessing ?? this.isProcessing,
      paymentCompleted: paymentCompleted ?? this.paymentCompleted,
    );
  }
}
