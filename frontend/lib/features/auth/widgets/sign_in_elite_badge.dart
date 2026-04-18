import 'package:flutter/material.dart';
import '../../../core/constants/auth_colors.dart';
import '../models/auth_placeholder_data.dart';

/// Rotated floating "ELITE ACCESS" badge.
class SignInEliteBadge extends StatelessWidget {
  const SignInEliteBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final text =
        (AuthPlaceholderData.signInPage['badge']
                as Map<String, dynamic>)['text']
            as String;

    return Transform.rotate(
      angle: 0.209, // ~12 degrees in radians
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AuthColors.lime,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AuthColors.onLime,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 2.5,
          ),
        ),
      ),
    );
  }
}
