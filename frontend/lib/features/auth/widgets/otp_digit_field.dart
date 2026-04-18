import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

/// Pure display widget for one OTP digit box.
/// All input is handled by the parent [OtpInputRow] hidden TextField.
class OtpDigitField extends StatelessWidget {
  const OtpDigitField({
    super.key,
    required this.digit,
    required this.placeholder,
    required this.width,
    required this.height,
    required this.isActive,
  });

  /// The character to show (empty string → show placeholder).
  final String digit;
  final String placeholder;
  final double width;
  final double height;

  /// True when this box is the next entry position (shows teal border).
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final double textSize = (height * 0.38).clamp(14.0, 22.0);
    final double radius = (height * 0.11).clamp(6.0, 10.0);
    final bool filled = digit.isNotEmpty;

    return SizedBox(
      width: width,
      height: height,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: AuthColors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isActive
                ? AuthColors.teal
                : filled
                ? AuthColors.outlineVariant
                : Colors.transparent,
            width: isActive ? 1.6 : 1.0,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          filled ? digit : placeholder,
          style: GoogleFonts.lexend(
            fontSize: textSize,
            fontWeight: FontWeight.w700,
            color: filled ? AuthColors.darkEmerald : AuthColors.outlineVariant,
          ),
        ),
      ),
    );
  }
}
