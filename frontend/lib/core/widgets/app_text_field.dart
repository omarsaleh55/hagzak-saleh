import 'package:flutter/material.dart';
import '../constants/auth_colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.errorText,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofillHints,
    this.scale = 1,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final double scale;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    final double radius = (14 * widget.scale).clamp(12.0, 16.0);
    final double labelSize = (12 * widget.scale).clamp(11.0, 13.0);
    final double fieldTextSize = (16 * widget.scale).clamp(15.0, 17.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: AuthColors.onSurfaceVariant,
            fontSize: labelSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.6 * widget.scale,
          ),
        ),
        SizedBox(height: (12 * widget.scale).clamp(10.0, 14.0)),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          textInputAction: widget.textInputAction,
          autofillHints: widget.autofillHints,
          style: TextStyle(
            color: AuthColors.darkEmerald,
            fontWeight: FontWeight.w500,
            fontSize: fieldTextSize,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AuthColors.hintText,
              fontWeight: FontWeight.w500,
              fontSize: fieldTextSize,
            ),
            filled: true,
            fillColor: const Color(0xFFE8EAE8),
            constraints: BoxConstraints(
              minHeight: (72 * widget.scale).clamp(66.0, 76.0),
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
              borderSide: const BorderSide(color: AuthColors.teal, width: 1.2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            errorText: widget.errorText,
            contentPadding: EdgeInsets.symmetric(
              horizontal: (18 * widget.scale).clamp(16.0, 22.0),
              vertical: (22 * widget.scale).clamp(20.0, 24.0),
            ),
          ),
        ),
      ],
    );
  }
}
