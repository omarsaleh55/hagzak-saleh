import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ForgotPasswordBackLink extends StatelessWidget {
  const ForgotPasswordBackLink({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.lexend(
              color: AuthColors.darkEmerald,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.chevron_right_rounded,
            color: AuthColors.darkEmerald,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class ForgotPasswordCopyright extends StatelessWidget {
  const ForgotPasswordCopyright({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.workSans(
          color: AuthColors.outlineVariant,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
          height: 1.4,
        ),
      ),
    );
  }
}
