import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/product_provider.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/cart_provider.dart';
import 'package:experience_app/features/ecommerce/presentation/views/product_detail_view.dart';
import 'package:experience_app/features/ecommerce/presentation/views/cart_view.dart';
import 'package:experience_app/features/auth/presentation/providers/dependency_injection.dart';
import 'package:experience_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:experience_app/features/auth/presentation/views/login_view.dart';

class EcommerceHomeView extends ConsumerStatefulWidget {
  const EcommerceHomeView({super.key});

  @override
  ConsumerState<EcommerceHomeView> createState() => _EcommerceHomeViewState();
}

class _EcommerceHomeViewState extends ConsumerState<EcommerceHomeView> {
  late PageController _pageController;
  int _currentPage = 0;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: productsAsync.when(
        data: (products) => _buildHomeContent(products),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, st) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildHomeContent(List<dynamic> products) {
    return Stack(
      children: [
        // Main Content
        SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Botón para agregar producto (solo visible para admins)
                    Consumer(
                      builder: (context, ref, child) {
                        final isAdminAsync = ref.watch(isAdminProvider);
                        return isAdminAsync.when(
                          data: (isAdmin) {
                            if (!isAdmin) {
                              return SizedBox.shrink();
                            }
                            return GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Función de agregar producto en desarrollo')),
                                );
                              },
                              child: Tooltip(
                                message: 'Agregar Producto',
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.green,
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            );
                          },
                          loading: () => SizedBox.shrink(),
                          error: (err, st) => SizedBox.shrink(),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.favorite_border,
                      size: 24,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const CartView(),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Consumer(
                              builder: (context, ref, child) {
                                final cartItems = ref.watch(cartProvider);
                                final itemCount = cartItems.length;

                                if (itemCount == 0) {
                                  return const SizedBox.shrink();
                                }

                                return Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      itemCount.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    // Botón de logout
                    GestureDetector(
                      onTap: () {
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
                                    MaterialPageRoute(builder: (_) => const LoginView()),
                                  );
                                },
                                child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Tooltip(
                        message: 'Cerrar Sesión',
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Carousel (Sin cambios)
              Container(
                height: 220,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          4,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Todos los Productos de Firebase
              if (products.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Todos los Productos',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return _buildProductCard(products[index]);
                        },
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No hay productos disponibles',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              SizedBox(height: 100),
            ],
          ),
        ),

        // Bottom Navigation Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.explore, 'Explore'),
                  _buildNavItem(1, Icons.category, 'Categories'),
                  _buildNavItem(2, Icons.store, 'Stores'),
                  _buildNavItem(3, Icons.person, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(dynamic product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailView(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(Icons.image, size: 60, color: Colors.grey.shade300),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '€ ${product.price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.grey.shade600,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
