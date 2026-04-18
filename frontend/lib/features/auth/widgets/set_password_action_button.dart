import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordActionButton extends StatelessWidget {
  const SetPasswordActionButton({
    super.key,
    required this.label,
    required this.scale,
    required this.onPressed,
  });

  final String label;
  final double scale;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: Size(double.infinity, (60 * scale).clamp(52.0, 72.0)),
          backgroundColor: AuthColors.lime,
          foregroundColor: AuthColors.onLime,
          padding: EdgeInsets.symmetric(
            horizontal: (18 * scale).clamp(14.0, 24.0),
            vertical: (16 * scale).clamp(12.0, 20.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((6 * scale).clamp(5.0, 10.0)),
          ),
        ),
        child: Wrap(
          spacing: (8 * scale).clamp(6.0, 12.0),
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.lexend(
                color: AuthColors.onLime,
                fontWeight: FontWeight.w800,
                fontSize: (18 * scale).clamp(15.0, 22.0),
              ),
            ),
            Icon(
              Icons.trending_flat,
              color: AuthColors.onLime,
              size: (20 * scale).clamp(18.0, 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
