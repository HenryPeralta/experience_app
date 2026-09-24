import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:experience_app/features/ecommerce/presentation/state/checkout_state.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_payment_cards.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/create_order_use_case.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/get_cart_items.dart';
import 'package:experience_app/features/ecommerce/domain/usecases/clear_cart.dart';
import 'package:experience_app/features/ecommerce/domain/entities/order.dart' as order_entity;
import 'package:experience_app/features/core/data/services/notifications_service.dart';
import 'dependency_injection.dart';
import 'product_provider.dart'; // ✅ Importar para acceder a allProductsProvider

// Payment cards provider
final paymentCardsProvider = FutureProvider((ref) async {
  final useCase = ref.watch(getPaymentCardsProvider);
  return await useCase();
});

// Checkout state notifier
class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final GetPaymentCards _getPaymentCardsUseCase;
  final CreateOrderUseCase _createOrderUseCase;
  final GetCartItems _getCartItemsUseCase;
  final ClearCart _clearCartUseCase;
  final Ref _ref; // ✅ Guardar ref para invalidar providers

  CheckoutNotifier({
    required GetPaymentCards getPaymentCardsUseCase,
    required CreateOrderUseCase createOrderUseCase,
    required GetCartItems getCartItemsUseCase,
    required ClearCart clearCartUseCase,
    required Ref ref, // ✅ Recibir ref
  })  : _getPaymentCardsUseCase = getPaymentCardsUseCase,
        _createOrderUseCase = createOrderUseCase,
        _getCartItemsUseCase = getCartItemsUseCase,
        _clearCartUseCase = clearCartUseCase,
        _ref = ref, // ✅ Guardar ref
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

  Future<String> processPayment() async {
    try {
      state = state.copyWith(isProcessing: true);
      
      // Obtener usuario actual
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Usuario no autenticado');

      // Obtener items del carrito
      final cartItems = await _getCartItemsUseCase();
      if (cartItems.isEmpty) throw Exception('El carrito está vacío');

      // ✅ VALIDAR STOCK antes de procesar
      for (final item in cartItems) {
        if (item.quantity > item.product.quantity) {
          throw Exception(
            'Stock insuficiente para ${item.product.title}. '
            'Disponible: ${item.product.quantity}, Solicitado: ${item.quantity}',
          );
        }
      }

      // Convertir CartItem a OrderItem
      final orderItems = cartItems.map((item) {
        return order_entity.OrderItem(
          productId: item.product.id,
          productName: item.product.title,
          price: item.product.price,
          quantity: item.quantity,
          size: item.selectedSize,
          color: item.selectedColor,
        );
      }).toList();

      // Calcular total
      double total = cartItems.fold(0, (sum, item) {
        return sum + (item.product.price * item.quantity);
      });

      // Crear orden
      final orderId = const Uuid().v4();
      final order = order_entity.PurchaseOrder(
        id: orderId,
        userId: user.uid,
        items: orderItems,
        total: total,
        status: 'completed', // ✅ La compra ya fue procesada exitosamente
        createdAt: DateTime.now(),
        shippingAddress: 'Default Address', // TODO: obtener dirección real
        paymentMethod: 'credit_card',
      );

      // Guardar orden en Firestore (con Batch que decrementa inventario)
      await _createOrderUseCase(order);

      // Enviar notificación push al usuario
      await NotificationsService.instance.showLocalNotification(
        id: orderId.hashCode,
        title: '¡Compra Realizada! 🎉',
        body: 'Tu orden #${orderId.substring(0, 8)} ha sido confirmada',
        payload: orderId,
      );

      // Limpiar carrito
      await _clearCartUseCase();

      // ✅ Invalidar provider de productos para refrescar stock
      _ref.invalidate(allProductsProvider);

      // Marcar como completado
      state = state.copyWith(
        isProcessing: false,
        currentStep: 3,
        paymentCompleted: true,
      );

      return orderId;
    } catch (e) {
      state = state.copyWith(isProcessing: false);
      print('❌ Error processing payment: $e');
      rethrow;
    }
  }
}

// Checkout provider
final checkoutProvider = StateNotifierProvider<CheckoutNotifier, CheckoutState>((ref) {
  final getPaymentCardsUseCase = ref.watch(getPaymentCardsProvider);
  final createOrderUseCase = ref.watch(createOrderProvider);
  final getCartItemsUseCase = ref.watch(getCartItemsProvider);
  final clearCartUseCase = ref.watch(clearCartProvider);
  
  return CheckoutNotifier(
    getPaymentCardsUseCase: getPaymentCardsUseCase,
    createOrderUseCase: createOrderUseCase,
    getCartItemsUseCase: getCartItemsUseCase,
    clearCartUseCase: clearCartUseCase,
    ref: ref, // ✅ Pasar ref
  );
});
