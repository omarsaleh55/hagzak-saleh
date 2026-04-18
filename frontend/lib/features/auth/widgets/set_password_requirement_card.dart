import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordRequirementCard extends StatelessWidget {
  const SetPasswordRequirementCard({
    super.key,
    required this.label,
    required this.met,
    required this.scale,
  });

  final String label;
  final bool met;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (10 * scale).clamp(9.0, 12.0),
        vertical: (6 * scale).clamp(5.0, 8.0),
      ),
      decoration: BoxDecoration(
        color: met
            ? AuthColors.teal.withValues(alpha: 0.10)
            : AuthColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: met
              ? AuthColors.teal.withValues(alpha: 0.35)
              : AuthColors.borderFaint,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            met ? Icons.check_circle_rounded : Icons.circle_outlined,
            color: met
                ? AuthColors.teal
                : AuthColors.outline.withValues(alpha: 0.4),
            size: (13 * scale).clamp(12.0, 15.0),
          ),
          SizedBox(width: (5 * scale).clamp(4.0, 6.0)),
          Text(
            label,
            style: GoogleFonts.workSans(
              color: met ? AuthColors.teal : AuthColors.outline,
              fontSize: (12 * scale).clamp(11.0, 13.0),
              fontWeight: met ? FontWeight.w600 : FontWeight.w400,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
