// lib/widgets/painters/trend_painter.dart

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TrendPainter extends CustomPainter {
  final List<int> temps;
  final Color color;

  TrendPainter({required this.temps, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (temps.length < 2) return;

    const padding = 20.0;
    const topPadding = 40.0; // Extra space for temp labels
    const bottomPadding = 30.0; // Space for day labels
    final chartWidth = size.width - padding * 2;
    final chartHeight = size.height - topPadding - bottomPadding;

    final minTemp = temps.reduce((a, b) => a < b ? a : b);
    final maxTemp = temps.reduce((a, b) => a > b ? a : b);
    final range = (maxTemp - minTemp).clamp(5, double.infinity);

    // Calculate nice reference values (multiples of 5)
    final refMin = (minTemp ~/ 5) * 5;
    final refMax = ((maxTemp + 4) ~/ 5) * 5;

    // ============================================================================
    // 1. DRAW REFERENCE LINES (DOTTED)
    // ============================================================================
    final referencePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int temp = refMin; temp <= refMax; temp += 5) {
      final y =
          topPadding + chartHeight - ((temp - minTemp) / range) * chartHeight;

      // Draw dotted line
      _drawDottedLine(
        canvas,
        Offset(padding, y),
        Offset(size.width - padding, y),
        referencePaint,
      );

      // Draw temperature label on left
      _drawText(
        canvas,
        '$temp°',
        Offset(5, y - 8),
        TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    // ============================================================================
    // 2. CALCULATE POINTS
    // ============================================================================
    final stepX = chartWidth / (temps.length - 1);
    final points = <Offset>[];

    double getY(int temp) {
      return topPadding +
          chartHeight -
          ((temp - minTemp) / range) * chartHeight;
    }

    for (int i = 0; i < temps.length; i++) {
      final x = padding + stepX * i;
      final y = getY(temps[i]);
      points.add(Offset(x, y));
    }

    // ============================================================================
    // 3. DRAW GRADIENT FILL
    // ============================================================================
    final fillPath = Path();
    fillPath.moveTo(points[0].dx, size.height - bottomPadding);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }

    fillPath.lineTo(points.last.dx, size.height - bottomPadding);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, topPadding),
        Offset(0, size.height - bottomPadding),
        [color.withOpacity(0.3), color.withOpacity(0.05)],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // ============================================================================
    // 4. DRAW LINE
    // ============================================================================
    final linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    // ============================================================================
    // 5. DRAW POINTS & TEMP LABELS
    // ============================================================================
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final temp = temps[i];
      final isMax = temp == maxTemp;
      final isMin = temp == minTemp;

      // Draw glow for min/max
      if (isMax || isMin) {
        final glowPaint = Paint()
          ..color = (isMax ? Colors.red : Colors.blue).withOpacity(0.3)
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8);
        canvas.drawCircle(point, 10, glowPaint);
      }

      // Draw outer circle
      final outerPaint = Paint()
        ..color = isMax ? Colors.red : (isMin ? Colors.blue : Colors.white)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 5, outerPaint);

      // Draw inner circle
      final innerPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, 3, innerPaint);

      // Draw temperature value ABOVE point
      _drawText(
        canvas,
        '$temp°',
        Offset(point.dx - 12, point.dy - 25),
        TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // ============================================================================
    // 6. DRAW DAY LABELS
    // ============================================================================
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < points.length && i < days.length; i++) {
      _drawText(
        canvas,
        days[i],
        Offset(points[i].dx - 12, size.height - bottomPadding + 8),
        TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11),
      );
    }
  }

  // ============================================================================
  // HELPER: DRAW DOTTED LINE
  // ============================================================================
  void _drawDottedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double distance = (end - start).distance;
    double drawnDistance = 0.0;

    while (drawnDistance < distance) {
      final startX =
          start.dx + (end.dx - start.dx) * (drawnDistance / distance);
      final startY =
          start.dy + (end.dy - start.dy) * (drawnDistance / distance);
      drawnDistance += dashWidth;
      final endX =
          start.dx +
          (end.dx - start.dx) * (drawnDistance / distance).clamp(0.0, 1.0);
      final endY =
          start.dy +
          (end.dy - start.dy) * (drawnDistance / distance).clamp(0.0, 1.0);
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      drawnDistance += dashSpace;
    }
  }

  // ============================================================================
  // HELPER: DRAW TEXT
  // ============================================================================
  void _drawText(Canvas canvas, String text, Offset position, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, position);
  }

  @override
  bool shouldRepaint(covariant TrendPainter oldDelegate) {
    return oldDelegate.temps != temps || oldDelegate.color != color;
  }
}
