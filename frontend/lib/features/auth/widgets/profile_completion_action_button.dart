import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ProfileCompletionActionButton extends StatelessWidget {
  const ProfileCompletionActionButton({
    super.key,
    required this.label,
    required this.scale,
    required this.onPressed,
  });

  final String label;
  final double scale;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(double.infinity, (64 * scale).clamp(56.0, 72.0)),
          backgroundColor: AuthColors.lime,
          foregroundColor: AuthColors.onLime,
          padding: EdgeInsets.symmetric(
            horizontal: (18 * scale).clamp(14.0, 24.0),
            vertical: (14 * scale).clamp(12.0, 18.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((14 * scale).clamp(12.0, 18.0)),
          ),
          shadowColor: const Color(0x4DCAF300),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool stack = constraints.maxWidth < 220;

            return Wrap(
              spacing: (10 * scale).clamp(8.0, 14.0),
              runSpacing: stack ? (4 * scale).clamp(2.0, 6.0) : 0,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: <Widget>[
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lexend(
                    color: AuthColors.onLime,
                    fontWeight: FontWeight.w800,
                    fontSize: (18 * scale).clamp(15.0, 22.0),
                    letterSpacing: -0.5,
                  ),
                ),
                Icon(
                  Icons.sports_soccer,
                  color: AuthColors.onLime,
                  size: (22 * scale).clamp(18.0, 24.0),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
