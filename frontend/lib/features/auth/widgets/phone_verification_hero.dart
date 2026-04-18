import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationHero extends StatelessWidget {
  const PhoneVerificationHero({
    super.key,
    required this.titleLine1,
    required this.titleLine2,
    required this.description,
    required this.scale,
  });

  final String titleLine1;
  final String titleLine2;
  final String description;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double titleSize = (27 * scale).clamp(25.0, 40.0);
    final double bodySize = (13 * scale).clamp(12.0, 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          titleLine1,
          style: GoogleFonts.lexend(
            color: AuthColors.darkEmerald,
            fontWeight: FontWeight.w800,
            fontSize: titleSize,
            height: 0.98,
            letterSpacing: -0.75,
          ),
        ),
        SizedBox(height: (2 * scale).clamp(1.0, 4.0)),
        Text(
          titleLine2,
          style: GoogleFonts.lexend(
            color: AuthColors.teal,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w800,
            fontSize: titleSize,
            height: 0.98,
            letterSpacing: -0.75,
          ),
        ),
        SizedBox(height: (12 * scale).clamp(10.0, 18.0)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: (292 * scale).clamp(250.0, 340.0),
          ),
          child: Text(
            description,
            style: GoogleFonts.workSans(
              color: AuthColors.onSurfaceVariant,
              fontSize: bodySize,
              height: 1.45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
