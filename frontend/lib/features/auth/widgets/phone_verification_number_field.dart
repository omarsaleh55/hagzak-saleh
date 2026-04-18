import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationNumberField extends StatelessWidget {
  const PhoneVerificationNumberField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.scale,
    this.errorText,
  });

  final TextEditingController controller;
  final String placeholder;
  final double scale;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      textAlignVertical: TextAlignVertical.center,
      style: GoogleFonts.lexend(
        color: AuthColors.darkEmerald,
        fontWeight: FontWeight.w600,
        fontSize: (11.6 * scale).clamp(11.0, 15.5),
      ),
      decoration: InputDecoration(
        isDense: true,
        constraints: BoxConstraints(minHeight: (48 * scale).clamp(46.0, 56.0)),
        hintText: placeholder,
        hintStyle: GoogleFonts.lexend(
          color: AuthColors.outline.withValues(alpha: 0.45),
          fontWeight: FontWeight.w600,
          fontSize: (11.6 * scale).clamp(11.0, 15.5),
        ),
        errorText: errorText,
        errorStyle: GoogleFonts.workSans(
          color: Colors.red.shade700,
          fontSize: (10 * scale).clamp(9.0, 12.0),
          height: 1.2,
        ),
        errorMaxLines: 3,
        filled: true,
        fillColor: AuthColors.surfaceContainerHighest,
        contentPadding: EdgeInsets.symmetric(
          horizontal: (12 * scale).clamp(11.0, 16.0),
          vertical: (13 * scale).clamp(12.0, 16.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular((8 * scale).clamp(8.0, 12.0)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular((8 * scale).clamp(8.0, 12.0)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular((8 * scale).clamp(8.0, 12.0)),
          borderSide: BorderSide(
            color: AuthColors.teal,
            width: (1.1 * scale).clamp(1.0, 1.6),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular((8 * scale).clamp(8.0, 12.0)),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: (1.1 * scale).clamp(1.0, 1.6),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular((8 * scale).clamp(8.0, 12.0)),
          borderSide: BorderSide(
            color: Colors.red.shade600,
            width: (1.1 * scale).clamp(1.0, 1.6),
          ),
        ),
      ),
    );
  }
}
