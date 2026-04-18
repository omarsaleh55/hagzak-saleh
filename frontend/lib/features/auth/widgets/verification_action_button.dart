import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class VerificationActionButton extends StatelessWidget {
  const VerificationActionButton({
    super.key,
    required this.label,
    this.scale = 1,
    required this.onPressed,
  });

  final String label;
  final double scale;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final double minHeight = (40 * scale).clamp(36.0, 64.0);
    final double labelSize = (16.5 * scale).clamp(14.0, 24.0);
    final double iconSize = (17 * scale).clamp(14.0, 24.0);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, minHeight),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
          backgroundColor: AuthColors.lime,
          foregroundColor: AuthColors.onLime,
          disabledBackgroundColor: AuthColors.surfaceContainerHighest,
          disabledForegroundColor: AuthColors.outline,
          padding: EdgeInsets.symmetric(
            horizontal: (14 * scale).clamp(12.0, 24.0),
            vertical: (9 * scale).clamp(8.0, 16.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((6 * scale).clamp(6.0, 12.0)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.lexend(
                fontSize: labelSize,
                fontWeight: FontWeight.w700,
                color: AuthColors.onLime,
              ),
            ),
            SizedBox(width: (6 * scale).clamp(6.0, 10.0)),
            Icon(Icons.chevron_right, size: iconSize, color: AuthColors.onLime),
          ],
        ),
      ),
    );
  }
}
