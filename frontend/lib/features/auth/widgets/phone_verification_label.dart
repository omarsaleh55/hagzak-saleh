import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationLabel extends StatelessWidget {
  const PhoneVerificationLabel({
    super.key,
    required this.text,
    required this.scale,
  });

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.workSans(
        color: AuthColors.darkEmerald,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2 * scale,
        fontSize: (9 * scale).clamp(8.0, 13.0),
      ),
    );
  }
}
