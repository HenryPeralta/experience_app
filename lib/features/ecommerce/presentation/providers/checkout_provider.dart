import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/data/models/payment_card_model.dart';

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  CheckoutNotifier()
      : super(
          CheckoutState(
            currentStep: 2,
            paymentCards: [
              PaymentCard(
                id: '1',
                type: 'mastercard',
                cardNumber: 'xxxx xxxx xxxx 1234',
                cardHolder: 'Mastercard',
                expiryDate: '12/25',
                cvv: '123',
              ),
              PaymentCard(
                id: '2',
                type: 'visa',
                cardNumber: 'xxxx xxxx xxxx 9876',
                cardHolder: 'Visa',
                expiryDate: '11/24',
                cvv: '456',
              ),
            ],
            selectedCardId: '1',
            selectedPaymentMethod: 'credit_card',
            sameBillingAddress: true,
          ),
        );

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void selectCard(String cardId) {
    state = state.copyWith(selectedCardId: cardId);
  }

  void selectPaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  void setSameBillingAddress(bool value) {
    state = state.copyWith(sameBillingAddress: value);
  }

  void processPayment() {
    state = state.copyWith(isProcessing: true);
    // Simular procesamiento
    Future.delayed(const Duration(seconds: 2), () {
      state = state.copyWith(
        isProcessing: false,
        currentStep: 3,
        paymentCompleted: true,
      );
    });
  }
}

class CheckoutState {
  final int currentStep; // 0: Your bag, 1: Shipping, 2: Payment, 3: Complete
  final List<PaymentCard> paymentCards;
  final String selectedCardId;
  final String selectedPaymentMethod; // 'credit_card', 'applepay'
  final bool sameBillingAddress;
  final bool isProcessing;
  final bool paymentCompleted;

  CheckoutState({
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

final checkoutProvider =
    StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier();
});
