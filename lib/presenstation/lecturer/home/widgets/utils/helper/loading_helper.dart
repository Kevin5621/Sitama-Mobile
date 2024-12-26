import 'package:sitama/core/config/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImmersiveLoadingWidget extends StatefulWidget {
  final String loadingText;
  final Color primaryColor;
  
  const ImmersiveLoadingWidget({
    super.key,
    this.loadingText = 'Loading data...',
    this.primaryColor = AppColors.lightPrimary,
  });

  @override
  State<ImmersiveLoadingWidget> createState() => _ImmersiveLoadingWidgetState();
}

class _ImmersiveLoadingWidgetState extends State<ImmersiveLoadingWidget> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer rotating circle
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.primaryColor.withAlpha((0.5*255).round()),
                          width: 4,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Inner pulsing circle
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.primaryColor.withAlpha((0.3*255).round()),
                      ),
                    ),
                  );
                },
              ),
              // Center progress indicator
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.primaryColor),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Loading text with fade effect
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: 0.5 + (_scaleAnimation.value - 0.8) / 0.8,
                child: Text(
                  widget.loadingText,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}