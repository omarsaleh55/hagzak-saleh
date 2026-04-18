import 'package:flutter/material.dart';
import '../../../core/constants/auth_colors.dart';
import '../models/auth_placeholder_data.dart';

/// "Don't have an account? Sign up" footer link.
class SignInFooter extends StatelessWidget {
  const SignInFooter({super.key, required this.onSignUp, this.scale = 1});

  final VoidCallback onSignUp;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final footer =
        AuthPlaceholderData.signInPage['footer'] as Map<String, dynamic>;
    final double textSize = (16 * scale).clamp(14.0, 18.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          footer['question'] as String,
          style: TextStyle(
            color: const Color(0xFF2A3330),
            fontSize: textSize,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: (6 * scale).clamp(4.0, 8.0)),
        GestureDetector(
          onTap: onSignUp,
          child: Text(
            footer['action'] as String,
            style: TextStyle(
              color: AuthColors.darkEmerald,
              fontSize: textSize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
