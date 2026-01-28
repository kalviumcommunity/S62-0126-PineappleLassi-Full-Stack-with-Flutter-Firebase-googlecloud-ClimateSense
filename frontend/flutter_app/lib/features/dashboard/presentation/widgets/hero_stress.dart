import 'package:flutter/material.dart';

class HeroStress extends StatelessWidget {
  final int stress;
  final AnimationController glowController;
  final AnimationController numberController;
  final Animation<int> numberAnimation;

  const HeroStress({
    super.key,
    required this.stress,
    required this.glowController,
    required this.numberController,
    required this.numberAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([glowController, numberController]),
      builder: (context, child) {
        final glowValue = 0.8 + (glowController.value * 0.2);
        final displayStress = numberController.isAnimating
            ? numberAnimation.value
            : stress;

        return Transform.scale(
          scale: numberController.isAnimating
              ? 1.0 + (numberController.value * 0.05)
              : 1.0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.3 * glowValue),
                  blurRadius: 80 * glowValue,
                  spreadRadius: 30 * glowValue,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$displayStress',
                  style: TextStyle(
                    fontSize: 140,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.9,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Climate Stress Index',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
