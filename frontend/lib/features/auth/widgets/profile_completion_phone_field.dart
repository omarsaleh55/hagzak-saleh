import 'package:flutter/material.dart';

import '../../../core/constants/auth_colors.dart';
import 'profile_completion_field_label.dart';
import 'profile_completion_text_input.dart';

class ProfileCompletionPhoneField extends StatelessWidget {
  const ProfileCompletionPhoneField({
    super.key,
    required this.label,
    required this.controller,
    required this.scale,
    this.errorText,
    this.readOnly = false,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final double scale;
  final String? errorText;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileCompletionFieldLabel(text: label, scale: scale),
        SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
        ProfileCompletionTextInput(
          controller: controller,
          placeholder: '',
          scale: scale,
          keyboardType: TextInputType.phone,
          readOnly: readOnly,
          onChanged: onChanged,
          errorText: errorText,
          suffixIcon: Icon(
            Icons.verified,
            color: AuthColors.teal,
            size: (22 * scale).clamp(18.0, 24.0),
          ),
        ),
      ],
    );
  }
}
