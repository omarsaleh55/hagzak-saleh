import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';
import 'profile_completion_field_label.dart';

class ProfileCompletionGenderField extends StatelessWidget {
  const ProfileCompletionGenderField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.scale,
    required this.onChanged,
    this.errorText,
  });

  final String label;
  final List<String> options;
  final String? value;
  final double scale;
  final ValueChanged<String?> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final double radius = (12 * scale).clamp(10.0, 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileCompletionFieldLabel(text: label, scale: scale),
        SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
        DropdownButtonFormField<String>(
          initialValue: value?.isEmpty == true ? null : value,
          onChanged: onChanged,
          style: GoogleFonts.workSans(
            color: AuthColors.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: (15 * scale).clamp(13.0, 18.0),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AuthColors.outline,
            size: (22 * scale).clamp(18.0, 24.0),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AuthColors.surfaceContainerHighest,
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
            errorStyle: GoogleFonts.workSans(
              color: Colors.red.shade700,
              fontSize: (11 * scale).clamp(10.0, 13.0),
              height: 1.25,
            ),
          ),
          items: options
              .map(
                (String option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
