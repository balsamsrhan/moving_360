import 'package:flutter/material.dart';
import 'package:moving_360/model/product_data.dart';
import 'product_360_viewer.dart';

class Product360ViewerHome extends StatefulWidget {
  const Product360ViewerHome({Key? key}) : super(key: key);

  @override
  State<Product360ViewerHome> createState() => _Product360ViewerHomeState();
}

class _Product360ViewerHomeState extends State<Product360ViewerHome>
    with SingleTickerProviderStateMixin {
  int _selectedProductIndex = 0;
  late AnimationController _transitionController;

  final List<ProductData> products = [
    ProductData(
      name: 'Adidas shoes',
      category: 'Premium Sneakers',
      price: '\$249.99',
      primaryColor: const Color(0xFF6366F1),
      secondaryColor: const Color(0xFF8B5CF6),
      accentColor: const Color(0xFFEC4899),
      icon: '👟',
    ),
    ProductData(
      name: 'Quantum Watch',
      category: 'Luxury Timepiece',
      price: '\$899.99',
      primaryColor: const Color(0xFF0EA5E9),
      secondaryColor: const Color(0xFF06B6D4),
      accentColor: const Color(0xFF8B5CF6),
      icon: '⌚',
    ),
    ProductData(
      name: 'Nexus Pro',
      category: 'Flagship Smartphone',
      price: '\$1,299.99',
      primaryColor: const Color(0xFF10B981),
      secondaryColor: const Color(0xFF14B8A6),
      accentColor: const Color(0xFF3B82F6),
      icon: '📱',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _changeProduct(int index) {
    if (index != _selectedProductIndex) {
      _transitionController.forward(from: 0.0);
      setState(() {
        _selectedProductIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProduct = products[_selectedProductIndex];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentProduct.primaryColor.withOpacity(0.1),
              currentProduct.secondaryColor.withOpacity(0.05),
              Colors.white,
              currentProduct.accentColor.withOpacity(0.08),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Product360Viewer(
                  product: currentProduct,
                  transitionAnimation: _transitionController,
                ),
              ),
              _buildProductInfo(currentProduct),
              _buildProductSelector(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.menu_rounded, size: 24),
          ),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                products[_selectedProductIndex].primaryColor,
                products[_selectedProductIndex].accentColor,
              ],
            ).createShader(bounds),
            child: const Text(
              'PREMIUM',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.shopping_bag_outlined, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(ProductData product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                ),
              );
            },
            child: Column(
              key: ValueKey(_selectedProductIndex),
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: product.primaryColor,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        product.primaryColor,
                        product.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: product.primaryColor.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelector() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(products.length, (index) {
          final isSelected = index == _selectedProductIndex;
          final product = products[index];

          return Expanded(
            child: GestureDetector(
              onTap: () => _changeProduct(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? product.primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: product.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.icon,
                      style: TextStyle(
                        fontSize: isSelected ? 32 : 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.name.split(' ')[0],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? product.primaryColor
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}