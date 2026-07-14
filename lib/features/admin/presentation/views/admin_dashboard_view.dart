import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/dependency_injection.dart';
import '../../../auth/presentation/views/login_view.dart';
import '../../../ecommerce/presentation/views/cart_view.dart';
import '../providers/admin_providers.dart';
import 'add_product_view.dart';

class AdminDashboardView extends ConsumerWidget {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserAsyncProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return Scaffold(
            body: Center(
              child: Text('Usuario no encontrado'),
            ),
          );
        }

        final productsAsync = ref.watch(getAdminProductsProvider(user.uid));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Panel Admin'),
            backgroundColor: Colors.green,
            actions: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    user.email,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Ver Carrito'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartView()),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Cerrar Sesión'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar drawer primero
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cerrar Sesión'),
                        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                              Navigator.of(context).popUntil((route) => route.isFirst);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginView(),
                                ),
                              );
                            },
                            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mis Productos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                productsAsync.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text('No tienes productos aún'),
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            child: ListTile(
                              leading: Image.network(
                                product.image,
                                width: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Container(
                                    width: 80,
                                    color: Colors.grey[300],
                                    child: Icon(Icons.image_not_supported),
                                  );
                                },
                              ),
                              title: Text(product.title),
                              subtitle: Text('\$${product.price}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteProduct(
                                    context,
                                    ref,
                                    product.id,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, st) => Expanded(
                    child: Center(
                      child: Text('Error: $err'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductView()),
              );
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        );
      },
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, st) => Scaffold(
        body: Center(
          child: Text('Error: $err'),
        ),
      ),
    );
  }

  void _deleteProduct(
    BuildContext context,
    WidgetRef ref,
    String productId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(deleteProductProvider)(productId);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
