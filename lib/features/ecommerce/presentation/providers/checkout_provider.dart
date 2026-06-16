import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/presentation/state/checkout_state.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_payment_cards.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/process_payment.dart';
import 'dependency_injection.dart';

// Payment cards provider
final paymentCardsProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getPaymentCardsProvider);
  return await useCase();
});

// Checkout state notifier
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final GetPaymentCards _getPaymentCardsUseCase;
  final ProcessPayment _processPaymentUseCase;

  CheckoutNotifier({
    required GetPaymentCards getPaymentCardsUseCase,
    required ProcessPayment processPaymentUseCase,
  })  : _getPaymentCardsUseCase = getPaymentCardsUseCase,
        _processPaymentUseCase = processPaymentUseCase,
        super(
          const CheckoutState(
            currentStep: 2,
            paymentCards: [],
            selectedCardId: '',
            selectedPaymentMethod: 'credit_card',
            sameBillingAddress: true,
          ),
        );

  Future<void> loadPaymentCards() async {
    try {
      final cards = await _getPaymentCardsUseCase();
      state = state.copyWith(
        paymentCards: cards,
        selectedCardId: cards.isNotEmpty ? cards.first.id : '',
      );
    } catch (e) {
      rethrow;
    }
  }

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

  Future<void> processPayment() async {
    try {
      state = state.copyWith(isProcessing: true);
      
      final selectedCard = state.paymentCards
          .firstWhere((card) => card.id == state.selectedCardId);
      
      // Process payment with cart total
      final success = await _processPaymentUseCase(selectedCard, 0.0);
      
      if (success) {
        state = state.copyWith(
          isProcessing: false,
          currentStep: 3,
          paymentCompleted: true,
        );
      } else {
        state = state.copyWith(isProcessing: false);
      }
    } catch (e) {
      state = state.copyWith(isProcessing: false);
      rethrow;
    }
  }
}

// Checkout provider
final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  final getPaymentCardsUseCase = ref.watch(getPaymentCardsProvider);
  final processPaymentUseCase = ref.watch(processPaymentProvider);
  
  return CheckoutNotifier(
    getPaymentCardsUseCase: getPaymentCardsUseCase,
    processPaymentUseCase: processPaymentUseCase,
  );
});
