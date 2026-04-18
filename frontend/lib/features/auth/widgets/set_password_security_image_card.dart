import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordSecurityImageCard extends StatelessWidget {
  const SetPasswordSecurityImageCard({
    super.key,
    required this.imageUrl,
    required this.caption,
    required this.scale,
  });

  final String imageUrl;
  final String caption;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final BorderRadius borderRadius = BorderRadius.circular(
          (16 * scale).clamp(16.0, 20.0),
        );
        final double width = constraints.maxWidth;
        final double height = (width * (width >= 640 ? 0.26 : 0.34)).clamp(
          118.0,
          190.0,
        );

        return ClipRRect(
          borderRadius: borderRadius,
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: AuthColors.emeraldDeep),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        AuthColors.darkEmerald.withValues(alpha: 0.0),
                        AuthColors.darkEmerald.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: (16 * scale).clamp(14.0, 20.0),
                  right: (16 * scale).clamp(14.0, 20.0),
                  bottom: (14 * scale).clamp(12.0, 18.0),
                  child: Text(
                    caption.toUpperCase(),
                    style: GoogleFonts.workSans(
                      color: AuthColors.lime,
                      fontSize: (10 * scale).clamp(9.0, 12.0),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
