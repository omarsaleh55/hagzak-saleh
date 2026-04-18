import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ForgotPasswordHero extends StatelessWidget {
  const ForgotPasswordHero({
    super.key,
    required this.badge,
    required this.titleLine1,
    required this.titleLine2,
    required this.description,
  });

  final String badge;
  final String titleLine1;
  final String titleLine2;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AuthColors.lime,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            badge,
            style: GoogleFonts.lexend(
              color: AuthColors.darkEmerald,
              fontWeight: FontWeight.w700,
              fontSize: 11,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          titleLine1,
          style: GoogleFonts.lexend(
            color: AuthColors.darkEmerald,
            fontWeight: FontWeight.w800,
            fontSize: 42,
            height: 0.95,
            letterSpacing: -1.5,
          ),
        ),
        Text(
          titleLine2,
          style: GoogleFonts.lexend(
            color: AuthColors.darkEmerald,
            fontWeight: FontWeight.w800,
            fontSize: 42,
            height: 0.95,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          description,
          style: GoogleFonts.workSans(
            color: AuthColors.onSurfaceVariant,
            fontSize: 15,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
