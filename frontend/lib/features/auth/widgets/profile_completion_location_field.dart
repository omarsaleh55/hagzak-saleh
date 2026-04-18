import 'package:flutter/material.dart';

import '../../../core/constants/auth_colors.dart';
import 'profile_completion_field_label.dart';
import 'profile_completion_text_input.dart';

/// Text field for the preferred pitch location with a map-picker suffix icon.
class ProfileCompletionLocationField extends StatelessWidget {
  const ProfileCompletionLocationField({
    super.key,
    required this.label,
    required this.controller,
    required this.placeholder,
    required this.scale,
    this.onChanged,
    this.errorText,
    this.onMapTap,
  });

  final String label;
  final TextEditingController controller;
  final String placeholder;
  final double scale;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  /// Called when the user taps the map icon to open the location picker.
  final VoidCallback? onMapTap;

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
          readOnly: true,
          onTap: onMapTap,
          onChanged: onChanged,
          errorText: errorText,
          prefixIcon: Icon(
            Icons.location_on,
            color: AuthColors.teal,
            size: (22 * scale).clamp(18.0, 24.0),
          ),
          suffixIcon: GestureDetector(
            onTap: onMapTap,
            child: Icon(
              Icons.map_outlined,
              color: AuthColors.teal,
              size: (22 * scale).clamp(18.0, 24.0),
            ),
          ),
          keyboardType: TextInputType.streetAddress,
        ),
      ],
    );
  }
}
