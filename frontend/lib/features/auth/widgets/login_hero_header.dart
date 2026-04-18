import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';
import '../models/auth_placeholder_data.dart';

class LoginHeroHeader extends StatelessWidget {
  const LoginHeroHeader({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    const data = AuthPlaceholderData.loginPage;
    final header = data['header'] as Map<String, dynamic>;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AuthColors.emerald950,
                    AuthColors.emeraldDeep,
                    AuthColors.teal,
                  ],
                ),
              ),
              child: SizedBox.expand(),
            ),
          ),
          Positioned(
            right: -20,
            bottom: -10,
            child: _SoccerBallGraphic(size: height * 0.7),
          ),
          Positioned(
            left: 24,
            bottom: 48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  header['title'] as String,
                  style: GoogleFonts.lexend(
                    color: AuthColors.lime,
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    letterSpacing: 1.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  header['subtitle'] as String,
                  style: GoogleFonts.workSans(
                    color: AuthColors.surfaceContainerLowest,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SoccerBallGraphic extends StatelessWidget {
  const _SoccerBallGraphic({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SoccerBallPainter()),
    );
  }
}

class _SoccerBallPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius, circlePaint);

    final pentagonPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final pentagonStrokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    _drawPentagon(canvas, center, radius * 0.35, pentagonPaint);
    _drawPentagon(canvas, center, radius * 0.35, pentagonStrokePaint);

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / 5);
      final innerX = center.dx + radius * 0.35 * math.cos(angle);
      final innerY = center.dy + radius * 0.35 * math.sin(angle);
      final outerX = center.dx + radius * 0.85 * math.cos(angle);
      final outerY = center.dy + radius * 0.85 * math.sin(angle);
      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        linePaint,
      );
    }
  }

  void _drawPentagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / 5);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
