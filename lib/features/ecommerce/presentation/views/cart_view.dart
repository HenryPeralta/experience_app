import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/cart_provider.dart';
import 'package:experience_app/features/ecommerce/presentation/views/checkout_view.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final totalAsync = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your bag',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: cartItemsAsync.when(
        data: (cartItems) => totalAsync.when(
          data: (total) => cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your bag is empty',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          children: [
                            ...cartItems.asMap().entries.map((entry) {
                              final index = entry.key;
                              final cartItem = entry.value;
                              final isLast = index == cartItems.length - 1;

                              return Column(
                                children: [
                                  _CartItemCard(cartItem: cartItem, ref: ref),
                                  if (!isLast)
                                    Divider(
                                      height: 24,
                                      color: Colors.grey.shade200,
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                        bottom: 40,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '€ ${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const CheckoutView(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Checkout',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, st) =>
              Center(child: Text('Error loading total: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, st) => Center(child: Text('Error loading cart: $error')),
      ),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  final dynamic cartItem;
  final WidgetRef ref;

  const _CartItemCard({required this.cartItem, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, size: 40, color: Color(0xFFBBDEFB)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cartItem.product.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${cartItem.product.category} / ${cartItem.selectedSize}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (cartItem.quantity == 1) {
                            // Eliminar del carrito cuando la cantidad es 1
                            await ref
                                .read(cartProvider.notifier)
                                .removeFromCart(cartItem);
                          } else {
                            // Decrementar cantidad
                            await ref
                                .read(cartProvider.notifier)
                                .updateQuantity(cartItem, cartItem.quantity - 1);
                          }

                          ref.invalidate(cartItemsProvider);
                          ref.invalidate(cartTotalProvider);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.remove,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${cartItem.quantity}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await ref
                              .read(cartProvider.notifier)
                              .updateQuantity(cartItem, cartItem.quantity + 1);

                          ref.invalidate(cartItemsProvider);
                          ref.invalidate(cartTotalProvider);
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '€ ${cartItem.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
