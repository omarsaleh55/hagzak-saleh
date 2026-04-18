import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationHelperText extends StatelessWidget {
  const PhoneVerificationHelperText({
    super.key,
    required this.text,
    required this.scale,
  });

  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.workSans(
          color: AuthColors.outline,
          fontStyle: FontStyle.italic,
          fontSize: (8 * scale).clamp(7.0, 12.0),
        ),
      ),
    );
  }
}
