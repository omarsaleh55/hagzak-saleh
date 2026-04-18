import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordMatchHint extends StatelessWidget {
  const SetPasswordMatchHint({
    super.key,
    required this.text,
    required this.scale,
  });

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.info_outline,
          size: (14 * scale).clamp(12.0, 16.0),
          color: AuthColors.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        SizedBox(width: (4 * scale).clamp(4.0, 6.0)),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.workSans(
              color: AuthColors.onSurfaceVariant.withValues(alpha: 0.6),
              fontSize: (10 * scale).clamp(9.0, 12.0),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
