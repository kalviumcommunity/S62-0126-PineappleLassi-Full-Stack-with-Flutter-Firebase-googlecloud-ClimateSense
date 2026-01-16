import 'package:flutter/material.dart';

class InteractiveWavePainter extends CustomPainter {
  final List<double> levels;
  final int selectedIndex;
  final Color accentColor;

  InteractiveWavePainter(this.levels, this.selectedIndex, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final wavePaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.white.withOpacity(0.25), Colors.white.withOpacity(0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final stepX = size.width / (levels.length - 1);
    final height = size.height;

    double startY = height - (levels[0] / 100) * height;
    path.moveTo(0, startY);
    fillPath.moveTo(0, height);
    fillPath.lineTo(0, startY);

    for (int i = 0; i < levels.length - 1; i++) {
      final x1 = i * stepX;
      final y1 = height - (levels[i] / 100) * height;
      final x2 = (i + 1) * stepX;
      final y2 = height - (levels[i + 1] / 100) * height;

      final cpX = (x1 + x2) / 2;

      path.cubicTo(cpX, y1, cpX, y2, x2, y2);
      fillPath.cubicTo(cpX, y1, cpX, y2, x2, y2);
    }

    fillPath.lineTo(size.width, height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, wavePaint);

    // Selected point indicator
    final selectedX = selectedIndex * stepX;
    final selectedY = height - (levels[selectedIndex] / 100) * height;

    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(Offset(selectedX, selectedY), 14, glowPaint);
    canvas.drawCircle(
      Offset(selectedX, selectedY),
      6,
      Paint()..color = accentColor,
    );
  }

  @override
  bool shouldRepaint(covariant InteractiveWavePainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.levels != levels;
  }
}
