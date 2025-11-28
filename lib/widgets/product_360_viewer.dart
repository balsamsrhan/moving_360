import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:moving_360/model/product_data.dart';

class Product360Viewer extends StatefulWidget {
  final ProductData product;
  final AnimationController transitionAnimation;
  final int frameCount;
  final double sensitivity;

  const Product360Viewer({
    Key? key,
    required this.product,
    required this.transitionAnimation,
    this.frameCount = 36,
    this.sensitivity = 1.5,
  }) : super(key: key);

  @override
  State<Product360Viewer> createState() => _Product360ViewerState();
}

class _Product360ViewerState extends State<Product360Viewer>
    with TickerProviderStateMixin {
  double _rotation = 0.0;
  double _startRotation = 0.0;
  bool _isDragging = false;
  late AnimationController _pulseController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
      _startRotation = _rotation;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotation = _startRotation + (details.localPosition.dx * widget.sensitivity);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Animated background rings
        _buildBackgroundRings(),

        // Main product viewer
        Center(
          child: GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _floatController,
                widget.transitionAnimation,
              ]),
              builder: (context, child) {
                final floatOffset = math.sin(_floatController.value * 2 * math.pi) * 15;
                final scale = 1.0 - (widget.transitionAnimation.value * 0.2);
                final opacity = 1.0 - widget.transitionAnimation.value;

                return Transform.translate(
                  offset: Offset(0, floatOffset),
                  child: Transform.scale(
                    scale: scale,
                    child: Opacity(
                      opacity: opacity,
                      child: _buildProductDisplay(),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundRings() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          children: List.generate(3, (index) {
            final scale = 0.6 + (index * 0.15) + (_pulseController.value * 0.1);
            final opacity = 0.03 - (index * 0.008);

            return Center(
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.product.primaryColor.withOpacity(opacity),
                      width: 2,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildProductDisplay() {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white,
            widget.product.primaryColor.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.product.primaryColor.withOpacity(0.2),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: Transform.rotate(
          angle: _rotation * 0.01,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              widget.product.icon,
              key: ValueKey(widget.product.icon),
              style: TextStyle(
                fontSize: 120,
                shadows: [
                  Shadow(
                    color: widget.product.primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}