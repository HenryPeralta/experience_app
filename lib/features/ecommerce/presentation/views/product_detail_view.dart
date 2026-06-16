import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/features/ecommerce/domain/entities/product.dart';
import 'package:experience_app/features/ecommerce/presentation/providers/cart_provider.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  @override
  ConsumerState<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends ConsumerState<ProductDetailView> {
  late PageController _pageController;
  int _currentImagePage = 0;
  late String? _selectedSize;
  late String? _selectedColor;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedSize = null;
    _selectedColor = null;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getColorFromHex(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel
                Container(
                  height: 320,
                  color: Colors.grey.shade100,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImagePage = index;
                          });
                        },
                        itemCount: 4,
                        itemBuilder: (_, index) {
                          return Center(
                            child: Icon(
                              Icons.image,
                              size: 120,
                              color: Colors.grey.shade400,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 10,
                        left: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // BOTON X
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  debugPrint("X PRESIONADA");
                                  Navigator.pop(context);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.close, size: 24),
                                  ),
                                ),
                              ),
                            ),

                            // BOTON FAVORITOS
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.favorite_border,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 16,
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
                                color: _currentImagePage == index
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

                // Product Info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '€ ${widget.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 24),

                      // Size Selection
                      Text(
                        'Size',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: widget.product.sizes
                            .map(
                              (size) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSize = _selectedSize == size
                                        ? null
                                        : size;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _selectedSize == size
                                        ? Colors.blue
                                        : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _selectedSize == size
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: _selectedSize == size
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 24),

                      // Color Selection
                      Text(
                        'Color',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: widget.product.colors
                            .map(
                              (colorHex) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedColor = _selectedColor == colorHex
                                        ? null
                                        : colorHex;
                                  });
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: _getColorFromHex(colorHex),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _selectedColor == colorHex
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Add to Bag Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_selectedSize == null || _selectedColor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select size and color'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    await ref
                        .read(cartProvider.notifier)
                        .addToCart(
                          widget.product,
                          1,
                          _selectedSize!,
                          _selectedColor!,
                        );

                    ref.invalidate(cartItemsProvider);
                    ref.invalidate(cartTotalProvider);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.product.title} added to bag!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Add to bag',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
