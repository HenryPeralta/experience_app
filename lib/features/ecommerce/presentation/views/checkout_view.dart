import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/checkout_provider.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/cart_provider.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/dependency_injection.dart';
import 'package:experience_app/features/ecommerce/presentation/state/checkout_state.dart';

class CheckoutView extends ConsumerWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider);
    final cartTotalAsync = ref.watch(cartTotalProvider);

    // Cargar tarjetas de pago cuando la pantalla se abre
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (checkoutState.paymentCards.isEmpty) {
        ref.read(checkoutProvider.notifier).loadPaymentCards();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: cartTotalAsync.when(
        data: (total) => Column(
          children: [
            // Progress Steps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StepIndicator(
                    label: 'Your bag',
                    isCompleted: true,
                    isActive: false,
                    onTap: () {},
                  ),
                  _StepIndicator(
                    label: 'Shipping',
                    isCompleted: true,
                    isActive: false,
                    onTap: () {},
                  ),
                  _StepIndicator(
                    label: 'Payment',
                    isCompleted: false,
                    isActive: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (checkoutState.currentStep == 3)
                      _CompletionStep(total: total)
                    else
                      _PaymentStep(ref: ref, checkoutState: checkoutState),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, st) => Center(
          child: Text('Error loading checkout: $error'),
        ),
      ),
      bottomSheet: cartTotalAsync.when(
        data: (total) => checkoutState.currentStep != 3
            ? Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: checkoutState.isProcessing
                        ? null
                        : () async {
                            try {
                              final orderId = await ref
                                  .read(checkoutProvider.notifier)
                                  .processPayment();

                              // Mostrar notificación local
                              final notificationService =
                                  ref.read(localNotificationServiceProvider);
                              await notificationService.showNotification(
                                id: orderId.hashCode,
                                title: '¡Compra Realizada! 🎉',
                                body:
                                    'Tu orden #${orderId.substring(0, 8)} ha sido confirmada',
                                payload: orderId,
                              );

                              // Refrescar estado del carrito
                              ref.invalidate(cartTotalProvider);
                              ref.invalidate(getCartItemsProvider);

                              // Mostrar modal de éxito
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      title: const Text(
                                        'Compra Realizada',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 64,
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            '¡Gracias por tu compra!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Orden #${orderId.substring(0, 8)}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        Center(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 32,
                                                vertical: 12,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context); // Cierra modal
                                              Navigator.pop(context); // Cierra checkout
                                              Navigator.pop(context); // Cierra cart
                                            },
                                            child: const Text(
                                              'Ir al Inicio',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    child: checkoutState.isProcessing
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Process Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              )
            : null,
        loading: () => null,
        error: (error, st) => null,
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String label;
  final bool isCompleted;
  final bool isActive;
  final VoidCallback onTap;

  const _StepIndicator({
    required this.label,
    required this.isCompleted,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.blue : (isActive ? Colors.blue : Colors.grey.shade200),
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      isActive ? '●' : '',
                      style: const TextStyle(color: Colors.blue, fontSize: 18),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.black : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentStep extends ConsumerWidget {
  final WidgetRef ref;
  final CheckoutState checkoutState;

  const _PaymentStep({
    required this.ref,
    required this.checkoutState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose a payment method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'You won\'t be charged until you review the order on the next page',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        // Credit Card Option
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: checkoutState.selectedPaymentMethod == 'credit_card'
                  ? Colors.blue
                  : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(checkoutProvider.notifier).selectPaymentMethod('credit_card');
                },
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: checkoutState.selectedPaymentMethod == 'credit_card'
                              ? Colors.blue
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: checkoutState.selectedPaymentMethod == 'credit_card'
                          ? Center(
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Credit Card',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (checkoutState.selectedPaymentMethod == 'credit_card')
                Column(
                  children: [
                    const SizedBox(height: 12),
                    ...checkoutState.paymentCards.map((card) {
                      final isSelected = card.id == checkoutState.selectedCardId;
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref.read(checkoutProvider.notifier).selectCard(card.id);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey.shade200,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.cardHolder,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        card.cardNumber,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle, color: Colors.blue),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        '+ Add new card',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Billing Address Checkbox
        GestureDetector(
          onTap: () {
            ref.read(checkoutProvider.notifier).setSameBillingAddress(
                  !checkoutState.sameBillingAddress,
                );
          },
          child: Row(
            children: [
              Checkbox(
                value: checkoutState.sameBillingAddress,
                onChanged: (value) {
                  ref.read(checkoutProvider.notifier).setSameBillingAddress(value ?? false);
                },
              ),
              Expanded(
                child: Text(
                  'My billing address is the same as my shipping address',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Apple Pay Option
        GestureDetector(
          onTap: () {
            ref.read(checkoutProvider.notifier).selectPaymentMethod('applepay');
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: checkoutState.selectedPaymentMethod == 'applepay'
                    ? Colors.blue
                    : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: checkoutState.selectedPaymentMethod == 'applepay'
                          ? Colors.blue
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: checkoutState.selectedPaymentMethod == 'applepay'
                      ? Center(
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Apple Pay',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CompletionStep extends StatelessWidget {
  final double total;

  const _CompletionStep({required this.total});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Order Confirmed!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thank you for your purchase',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Order Total:'),
                    Text(
                      '€ ${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
