import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/dependency_injection.dart';
import 'package:experience_app/features/ecommerce/presentation/views/order_detail_view.dart';

class OrdersHistoryView extends ConsumerWidget {
  const OrdersHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Compras'),
        elevation: 0,
      ),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes compras aún',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Realiza tu primera compra',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
              final formattedDate = dateFormat.format(order.createdAt);

              // Determinar color según estado
              final statusColor = _getStatusColor(order.status);
              final statusLabel = _getStatusLabel(order.status);

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderDetailView(orderId: order.id),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Encabezado con ID y estado
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Orden #${order.id.substring(0, 8).toUpperCase()}',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formattedDate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        // Resumen de productos
                        Text(
                          '${order.items.length} producto${order.items.length > 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        // Lista de items (máximo 2)
                        ...order.items
                            .take(2)
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.productName} x${item.quantity}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        if (order.items.length > 2)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '+${order.items.length - 2} más',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        const SizedBox(height: 12),
                        const Divider(),
                        const SizedBox(height: 12),
                        // Total
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$${order.total.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Error al cargar compras',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.teal;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'Completada ✅';
      case 'shipped':
        return 'Enviada 📦';
      case 'delivered':
        return 'Entregada 🎉';
      case 'pending':
        return 'Pendiente ⏳';
      default:
        return status;
    }
  }
}
