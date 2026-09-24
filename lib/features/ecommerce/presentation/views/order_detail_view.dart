import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/dependency_injection.dart';

class OrderDetailView extends ConsumerWidget {
  final String orderId;

  const OrderDetailView({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailProvider(orderId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Compra'),
        elevation: 0,
      ),
      body: orderAsync.when(
        data: (order) {
          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Compra no encontrada',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
          final formattedDate = dateFormat.format(order.createdAt);
          final statusColor = _getStatusColor(order.status);
          final statusLabel = _getStatusLabel(order.status);
          final statusIcon = _getStatusIcon(order.status);

          return SingleChildScrollView(
            child: Column(
              children: [
                // Encabezado con estado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepPurple.shade400,
                        Colors.deepPurple.shade600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        statusIcon,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        statusLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Orden #${order.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Contenido principal
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información general
                      _buildSectionCard(
                        context,
                        title: 'Información de la Orden',
                        children: [
                          _buildInfoRow(
                            context,
                            label: 'Fecha de compra:',
                            value: formattedDate,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            context,
                            label: 'Estado:',
                            value: statusLabel,
                            valueColor: statusColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Productos
                      _buildSectionCard(
                        context,
                        title: 'Productos (${order.items.length})',
                        children: [
                          ...order.items.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return Column(
                                children: [
                                  _buildProductItem(context, item),
                                  if (index < order.items.length - 1)
                                    const Divider(height: 16),
                                ],
                              );
                            },
                          ).toList(),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Resumen de precios
                      _buildSectionCard(
                        context,
                        title: 'Resumen de Pago',
                        children: [
                          _buildPriceSummary(
                            context,
                            label: 'Subtotal:',
                            value: order.items.fold<double>(
                              0,
                              (sum, item) => sum + (item.price * item.quantity),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildPriceSummary(
                            context,
                            label: 'Envío:',
                            value: 0, // Puedes ajustar esto si tienes gastos de envío
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          _buildPriceSummary(
                            context,
                            label: 'Total:',
                            value: order.total,
                            isBold: true,
                            isTotal: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Dirección de envío
                      _buildSectionCard(
                        context,
                        title: 'Dirección de Envío',
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  order.shippingAddress,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Método de pago
                      _buildSectionCard(
                        context,
                        title: 'Método de Pago',
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.credit_card_outlined,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  order.paymentMethod,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Botón de acción
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Volver'),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
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
                'Error al cargar la compra',
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

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
        ),
      ],
    );
  }

  Widget _buildProductItem(BuildContext context, dynamic item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cantidad: ${item.quantity} | Precio: \$${item.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '\$${(item.price * item.quantity).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSummary(
    BuildContext context, {
    required String label,
    required double value,
    bool isBold = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 16 : 14,
              ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 18 : 14,
                color: isTotal ? Colors.deepPurple : null,
              ),
        ),
      ],
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
        return 'Compra Completada ✅';
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

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle_outline;
      case 'shipped':
        return Icons.local_shipping_outlined;
      case 'delivered':
        return Icons.done_all_outlined;
      case 'pending':
        return Icons.schedule_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
