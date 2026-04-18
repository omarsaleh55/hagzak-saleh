import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordInputField extends StatelessWidget {
  const SetPasswordInputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.obscureText,
    required this.scale,
    this.controller,
    this.onChanged,
    this.onToggleVisibility,
  });

  final String label;
  final String placeholder;
  final bool obscureText;
  final double scale;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    final double radius = (12 * scale).clamp(10.0, 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.workSans(
            color: AuthColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            fontSize: (12 * scale).clamp(11.0, 14.0),
            letterSpacing: 0.9,
          ),
        ),
        SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
        Container(
          height: (56 * scale).clamp(54.0, 64.0),
          decoration: BoxDecoration(
            color: AuthColors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  obscureText: obscureText,
                  textAlignVertical: TextAlignVertical.center,
                  style: GoogleFonts.workSans(
                    color: AuthColors.darkEmerald,
                    fontSize: (15 * scale).clamp(13.0, 18.0),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: GoogleFonts.workSans(
                      color: AuthColors.hintText,
                      fontSize: (15 * scale).clamp(13.0, 18.0),
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: (16 * scale).clamp(14.0, 20.0),
                      vertical: (16 * scale).clamp(14.0, 18.0),
                    ),
                  ),
                ),
              ),
              if (onToggleVisibility != null)
                IconButton(
                  onPressed: onToggleVisibility,
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AuthColors.outline,
                    size: (21 * scale).clamp(19.0, 24.0),
                  ),
                  splashRadius: 20,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
