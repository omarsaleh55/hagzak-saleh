import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ResendCodeSection extends StatelessWidget {
  const ResendCodeSection({
    super.key,
    required this.question,
    required this.actionLabel,
    this.scale = 1,
    required this.onResend,
  });

  final String question;
  final String actionLabel;
  final double scale;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final double labelSize = (9 * scale).clamp(8.0, 14.0);
    final double actionSize = (12 * scale).clamp(10.0, 22.0);

    return Column(
      children: [
        Text(
          question.toUpperCase(),
          style: GoogleFonts.workSans(
            fontSize: labelSize,
            color: const Color(0xFF66706B),
            letterSpacing: 2.8,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: (10 * scale).clamp(8.0, 16.0)),
        TextButton(
          onPressed: onResend,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            actionLabel,
            style: GoogleFonts.workSans(
              color: AuthColors.teal,
              fontSize: actionSize,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ],
    );
  }
}
