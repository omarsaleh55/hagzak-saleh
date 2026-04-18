import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ProfileCompletionHero extends StatelessWidget {
  const ProfileCompletionHero({
    super.key,
    required this.stepLabel,
    required this.titleLine1,
    required this.titleLine2,
    required this.scale,
  });

  final String stepLabel;
  final String titleLine1;
  final String titleLine2;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final bool hasStepLabel = stepLabel.trim().isNotEmpty;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double accentWidth = (constraints.maxWidth * 0.8).clamp(
          120.0,
          constraints.maxWidth,
        );

        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              top: (-12 * scale).clamp(-14.0, -8.0),
              left: (-6 * scale).clamp(-8.0, -2.0),
              child: Container(
                width: (96 * scale).clamp(72.0, 120.0),
                height: (96 * scale).clamp(72.0, 120.0),
                decoration: BoxDecoration(
                  color: AuthColors.lime.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (hasStepLabel) ...<Widget>[
                  Text(
                    stepLabel.toUpperCase(),
                    style: GoogleFonts.workSans(
                      color: AuthColors.limeDim,
                      fontWeight: FontWeight.w700,
                      fontSize: (10 * scale).clamp(9.0, 12.0),
                      letterSpacing: 1.7 * scale,
                    ),
                  ),
                  SizedBox(height: (10 * scale).clamp(8.0, 14.0)),
                ],
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.lexend(
                      fontSize: (34 * scale).clamp(28.0, 46.0),
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                      letterSpacing: -1.1,
                      color: AuthColors.darkEmerald,
                    ),
                    children: <InlineSpan>[
                      TextSpan(text: '$titleLine1\n'),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: <Color>[
                                AuthColors.darkEmerald,
                                AuthColors.teal,
                                AuthColors.darkEmerald,
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            titleLine2,
                            style: GoogleFonts.lexend(
                              fontSize: (34 * scale).clamp(28.0, 46.0),
                              fontWeight: FontWeight.w800,
                              height: 1.05,
                              letterSpacing: -1.1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: (20 * scale).clamp(16.0, 24.0)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: accentWidth,
                    height: (4 * scale).clamp(3.0, 5.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: <Color>[
                          Colors.transparent,
                          AuthColors.lime,
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
