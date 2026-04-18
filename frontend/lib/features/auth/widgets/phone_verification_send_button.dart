import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationSendButton extends StatelessWidget {
  const PhoneVerificationSendButton({
    super.key,
    required this.label,
    required this.scale,
    this.onPressed,
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
          minimumSize: Size(double.infinity, (50 * scale).clamp(48.0, 60.0)),
          backgroundColor: AuthColors.lime,
          foregroundColor: AuthColors.onLime,
          disabledBackgroundColor: const Color(0xFFDDE1E0),
          disabledForegroundColor: AuthColors.outline,
          padding: EdgeInsets.symmetric(
            horizontal: (16 * scale).clamp(14.0, 20.0),
            vertical: (12 * scale).clamp(10.0, 16.0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((8 * scale).clamp(8.0, 12.0)),
          ),
        ),
        child: Wrap(
          spacing: (8 * scale).clamp(6.0, 10.0),
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: GoogleFonts.lexend(
                fontWeight: FontWeight.w700,
                fontSize: (14 * scale).clamp(13.0, 18.0),
              ),
            ),
            Icon(Icons.arrow_forward, size: (18 * scale).clamp(16.0, 20.0)),
          ],
        ),
      ),
    );
  }
}
