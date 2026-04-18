import 'package:flutter/material.dart';

import '../../../core/constants/auth_colors.dart';
import 'profile_completion_field_label.dart';
import 'profile_completion_text_input.dart';

class ProfileCompletionDateField extends StatelessWidget {
  const ProfileCompletionDateField({
    super.key,
    required this.label,
    required this.controller,
    required this.scale,
    required this.onTap,
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final double scale;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileCompletionFieldLabel(text: label, scale: scale),
        SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
        ProfileCompletionTextInput(
          controller: controller,
          placeholder: '2000-01-01',
          scale: scale,
          readOnly: true,
          onTap: onTap,
          errorText: errorText,
          suffixIcon: Icon(
            Icons.calendar_month_outlined,
            color: AuthColors.outline,
            size: (20 * scale).clamp(18.0, 22.0),
          ),
        ),
      ],
    );
  }
}
