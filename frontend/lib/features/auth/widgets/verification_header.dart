import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

/// Branding + Email description header for verification.
class VerificationHeader extends StatelessWidget {
  const VerificationHeader({
    super.key,
    required this.title,
    required this.descriptionPrefix,
    required this.email,
    required this.descriptionSuffix,
    this.scale = 1,
  });

  final String title;
  final String descriptionPrefix;
  final String email;
  final String descriptionSuffix;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double titleSize = (28 * scale).clamp(24.0, 48.0);
    final double bodySize = (13 * scale).clamp(11.0, 20.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lexend(
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            color: AuthColors.darkEmerald,
            letterSpacing: -0.7,
            height: 1.1,
          ),
        ),
        SizedBox(height: (14 * scale).clamp(10.0, 22.0)),
        RichText(
          text: TextSpan(
            style: GoogleFonts.workSans(
              fontSize: bodySize,
              color: AuthColors.onSurfaceVariant,
              height: 1.45,
            ),
            children: [
              TextSpan(text: descriptionPrefix),
              TextSpan(
                text: email,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AuthColors.darkEmerald,
                ),
              ),
              TextSpan(text: descriptionSuffix),
            ],
          ),
        ),
      ],
    );
  }
}
