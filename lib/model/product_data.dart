import 'dart:ui';

class ProductData {
  final String name;
  final String category;
  final String price;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String icon;

  ProductData({
    required this.name,
    required this.category,
    required this.price,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    required this.icon,
  });
}