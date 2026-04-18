import 'package:flutter/material.dart';

import 'profile_completion_field_label.dart';
import 'profile_completion_text_input.dart';

class ProfileCompletionFullNameField extends StatelessWidget {
  const ProfileCompletionFullNameField({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.scale,
    this.onChanged,
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final String placeholder;
  final double scale;
  final ValueChanged<String>? onChanged;
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
          placeholder: placeholder,
          scale: scale,
          keyboardType: TextInputType.name,
          onChanged: onChanged,
          errorText: errorText,
        ),
      ],
    );
  }
}
