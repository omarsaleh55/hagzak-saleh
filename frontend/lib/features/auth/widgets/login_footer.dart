import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';
import '../models/auth_placeholder_data.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key, required this.onSignUp});

  final VoidCallback onSignUp;

  @override
  Widget build(BuildContext context) {
    final footer =
        AuthPlaceholderData.loginPage['footer'] as Map<String, dynamic>;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          footer['question'] as String,
          style: GoogleFonts.workSans(
            color: AuthColors.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onSignUp,
          child: Text(
            footer['action'] as String,
            style: GoogleFonts.workSans(
              color: AuthColors.darkEmerald,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: AuthColors.darkEmerald,
            ),
          ),
        ),
      ],
    );
  }
}
