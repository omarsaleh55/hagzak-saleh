import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ProfileCompletionTextInput extends StatelessWidget {
  const ProfileCompletionTextInput({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.scale,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController controller;
  final String placeholder;
  final double scale;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final double radius = (12 * scale).clamp(10.0, 16.0);

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      textAlignVertical: TextAlignVertical.center,
      style: GoogleFonts.workSans(
        color: AuthColors.onSurface,
        fontWeight: FontWeight.w500,
        fontSize: (15 * scale).clamp(13.0, 18.0),
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.workSans(
          color: AuthColors.onSurfaceVariant.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
          fontSize: (15 * scale).clamp(13.0, 18.0),
        ),
        filled: true,
        fillColor: AuthColors.surfaceContainerHighest,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixIconConstraints: BoxConstraints(
          minWidth: (44 * scale).clamp(40.0, 52.0),
        ),
        suffixIconConstraints: BoxConstraints(
          minWidth: (44 * scale).clamp(40.0, 52.0),
        ),
        constraints: BoxConstraints(minHeight: (56 * scale).clamp(52.0, 66.0)),
        contentPadding: EdgeInsets.symmetric(
          horizontal: (16 * scale).clamp(14.0, 20.0),
          vertical: (16 * scale).clamp(14.0, 18.0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AuthColors.teal,
            width: (1.2 * scale).clamp(1.0, 1.8),
          ),
        ),
        errorText: errorText,
        errorMaxLines: 3,
        errorStyle: GoogleFonts.workSans(
          color: Colors.red.shade700,
          fontSize: (11 * scale).clamp(10.0, 13.0),
          height: 1.25,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: Colors.red.shade400,
            width: (1.1 * scale).clamp(1.0, 1.6),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: Colors.red.shade600,
            width: (1.2 * scale).clamp(1.0, 1.8),
          ),
        ),
      ),
    );
  }
}
