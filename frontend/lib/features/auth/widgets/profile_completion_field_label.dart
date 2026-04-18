import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ProfileCompletionFieldLabel extends StatelessWidget {
  const ProfileCompletionFieldLabel({
    super.key,
    required this.text,
    required this.scale,
  });

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: (4 * scale).clamp(2.0, 6.0)),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.workSans(
          color: AuthColors.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          fontSize: (10 * scale).clamp(9.0, 12.0),
          letterSpacing: 1.1 * scale,
        ),
      ),
    );
  }
}
