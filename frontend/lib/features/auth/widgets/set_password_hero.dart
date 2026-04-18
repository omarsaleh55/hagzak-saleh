import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordHero extends StatelessWidget {
  const SetPasswordHero({
    super.key,
    required this.stepLabel,
    required this.titleLine1,
    required this.titleLine2,
    required this.description,
    required this.scale,
  });

  final String stepLabel;
  final String titleLine1;
  final String titleLine2;
  final String description;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double descriptionWidth = (constraints.maxWidth * 0.72).clamp(
          250.0,
          360.0,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (stepLabel.trim().isNotEmpty) ...<Widget>[
              Text(
                stepLabel,
                style: GoogleFonts.workSans(
                  color: AuthColors.limeDim,
                  fontWeight: FontWeight.w700,
                  fontSize: (10 * scale).clamp(9.0, 12.0),
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: (10 * scale).clamp(8.0, 12.0)),
            ],
            Text(
              titleLine1,
              style: GoogleFonts.lexend(
                color: AuthColors.darkEmerald,
                fontWeight: FontWeight.w800,
                fontSize: (40 * scale).clamp(31.0, 52.0),
                letterSpacing: -1.4,
                height: 0.92,
              ),
            ),
            Text(
              titleLine2,
              style: GoogleFonts.lexend(
                color: AuthColors.teal,
                fontWeight: FontWeight.w800,
                fontSize: (40 * scale).clamp(31.0, 52.0),
                letterSpacing: -1.4,
                height: 0.92,
              ),
            ),
            SizedBox(height: (18 * scale).clamp(14.0, 24.0)),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: descriptionWidth),
              child: Text(
                description,
                style: GoogleFonts.workSans(
                  color: AuthColors.onSurfaceVariant,
                  fontSize: (15 * scale).clamp(13.0, 18.0),
                  height: 1.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
