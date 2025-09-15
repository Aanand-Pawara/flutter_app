import 'package:flutter/material.dart';
import 'dart:math' as math;

class GearBackgroundPainter extends CustomPainter {
  final double animationValue;

  GearBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1AFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final fillPaint = Paint()
      ..color = const Color(0x0DFFFFFF)
      ..style = PaintingStyle.fill;

    // Draw multiple animated gears
    _drawGear(canvas, size, Offset(size.width * 0.1, size.height * 0.2), 40, paint, fillPaint, animationValue);
    _drawGear(canvas, size, Offset(size.width * 0.3, size.height * 0.1), 60, paint, fillPaint, -animationValue * 0.8);
    _drawGear(canvas, size, Offset(size.width * 0.2, size.height * 0.4), 35, paint, fillPaint, animationValue * 1.2);
    _drawGear(canvas, size, Offset(size.width * 0.05, size.height * 0.6), 50, paint, fillPaint, -animationValue * 0.6);
    _drawGear(canvas, size, Offset(size.width * 0.25, size.height * 0.7), 45, paint, fillPaint, animationValue * 0.9);
    _drawGear(canvas, size, Offset(size.width * 0.1, size.height * 0.85), 55, paint, fillPaint, -animationValue * 1.1);
    
    // Large central gear
    _drawGear(canvas, size, Offset(size.width * 0.15, size.height * 0.5), 80, paint, fillPaint, animationValue * 0.5);
    
    // Small decorative gears
    _drawGear(canvas, size, Offset(size.width * 0.35, size.height * 0.3), 25, paint, fillPaint, -animationValue * 1.5);
    _drawGear(canvas, size, Offset(size.width * 0.32, size.height * 0.55), 30, paint, fillPaint, animationValue * 1.3);
    _drawGear(canvas, size, Offset(size.width * 0.38, size.height * 0.8), 28, paint, fillPaint, -animationValue * 0.7);
  }

  void _drawGear(Canvas canvas, Size size, Offset center, double radius, Paint strokePaint, Paint fillPaint, double rotation) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation * 2 * math.pi);

    final path = Path();
    const int teeth = 12;
    const double toothHeight = 8.0;
    
    for (int i = 0; i < teeth; i++) {
      final double angle = (i * 2 * math.pi) / teeth;
      final double nextAngle = ((i + 1) * 2 * math.pi) / teeth;
      
      // Outer tooth point
      final double outerX = (radius + toothHeight) * math.cos(angle);
      final double outerY = (radius + toothHeight) * math.sin(angle);
      
      // Inner tooth points
      final double innerX1 = radius * math.cos(angle + 0.1);
      final double innerY1 = radius * math.sin(angle + 0.1);
      final double innerX2 = radius * math.cos(nextAngle - 0.1);
      final double innerY2 = radius * math.sin(nextAngle - 0.1);
      
      if (i == 0) {
        path.moveTo(innerX1, innerY1);
      }
      
      path.lineTo(outerX, outerY);
      path.lineTo(innerX2, innerY2);
      
      if (i < teeth - 1) {
        final double nextInnerX = radius * math.cos(nextAngle + 0.1);
        final double nextInnerY = radius * math.sin(nextAngle + 0.1);
        path.lineTo(nextInnerX, nextInnerY);
      }
    }
    
    path.close();
    
    // Draw filled gear
    canvas.drawPath(path, fillPaint);
    
    // Draw gear outline
    canvas.drawPath(path, strokePaint);
    
    // Draw inner circle
    canvas.drawCircle(Offset.zero, radius * 0.3, strokePaint);
    canvas.drawCircle(Offset.zero, radius * 0.3, fillPaint);
    
    // Draw center hole
    canvas.drawCircle(Offset.zero, radius * 0.15, Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is GearBackgroundPainter && oldDelegate.animationValue != animationValue;
  }
}
