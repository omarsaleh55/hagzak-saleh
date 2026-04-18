import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordSuccessHint extends StatelessWidget {
  const SetPasswordSuccessHint({
    super.key,
    required this.text,
    required this.scale,
  });

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (18 * scale).clamp(14.0, 22.0),
        vertical: (12 * scale).clamp(10.0, 14.0),
      ),
      decoration: BoxDecoration(
        color: AuthColors.teal.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: (8 * scale).clamp(6.0, 10.0),
            height: (8 * scale).clamp(6.0, 10.0),
            decoration: const BoxDecoration(
              color: AuthColors.teal,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: (10 * scale).clamp(8.0, 12.0)),
          Flexible(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.workSans(
                color: AuthColors.teal,
                fontWeight: FontWeight.w600,
                fontSize: (11 * scale).clamp(10.0, 13.0),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
