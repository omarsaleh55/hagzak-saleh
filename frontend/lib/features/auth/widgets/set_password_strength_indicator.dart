import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordStrengthIndicator extends StatelessWidget {
  const SetPasswordStrengthIndicator({
    super.key,
    required this.label,
    required this.hint,
    required this.activeCount,
    required this.scale,
  });

  final String label;
  final String hint;
  final int activeCount;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final List<Widget> bars = List<Widget>.generate(4, (int index) {
      final bool active = index < activeCount;
      return Expanded(
        child: Container(
          height: (6 * scale).clamp(5.0, 7.0),
          decoration: BoxDecoration(
            color: active
                ? AuthColors.lime
                : AuthColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(999),
            boxShadow: active
                ? const <BoxShadow>[
                    BoxShadow(color: AuthColors.limeGlow, blurRadius: 8),
                  ]
                : const <BoxShadow>[],
          ),
        ),
      );
    });

    return Padding(
      padding: EdgeInsets.only(top: (2 * scale).clamp(1.0, 4.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              bars[0],
              SizedBox(width: (4 * scale).clamp(4.0, 6.0)),
              bars[1],
              SizedBox(width: (4 * scale).clamp(4.0, 6.0)),
              bars[2],
              SizedBox(width: (4 * scale).clamp(4.0, 6.0)),
              bars[3],
            ],
          ),
          SizedBox(height: (6 * scale).clamp(5.0, 8.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                label.toUpperCase(),
                style: GoogleFonts.workSans(
                  color: AuthColors.limeDim,
                  fontWeight: FontWeight.w700,
                  fontSize: (10 * scale).clamp(9.0, 12.0),
                  letterSpacing: -0.1,
                ),
              ),
              Text(
                hint.toUpperCase(),
                style: GoogleFonts.workSans(
                  color: AuthColors.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: (10 * scale).clamp(9.0, 12.0),
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
