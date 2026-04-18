import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class SetPasswordFooterActionArea extends StatelessWidget {
  const SetPasswordFooterActionArea({
    super.key,
    required this.buttonLabel,
    required this.termsText,
    required this.scale,
    required this.bottomInset,
    required this.maxWidth,
    required this.horizontalPadding,
    this.onPressed,
  });

  final String buttonLabel;
  final String termsText;
  final double scale;
  final double bottomInset;
  final double maxWidth;
  final double horizontalPadding;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: AuthColors.surface.withValues(alpha: 0.9),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            (18 * scale).clamp(16.0, 22.0),
            horizontalPadding,
            bottomInset + (18 * scale).clamp(16.0, 24.0),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AuthColors.lime,
                        foregroundColor: AuthColors.onLime,
                        disabledBackgroundColor:
                            AuthColors.surfaceContainerHighest,
                        disabledForegroundColor: AuthColors.outline,
                        minimumSize: Size(
                          double.infinity,
                          (62 * scale).clamp(56.0, 70.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: (20 * scale).clamp(16.0, 24.0),
                          vertical: (18 * scale).clamp(16.0, 22.0),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            (14 * scale).clamp(12.0, 16.0),
                          ),
                        ),
                        shadowColor: AuthColors.lime.withValues(alpha: 0.3),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: (8 * scale).clamp(6.0, 10.0),
                        runSpacing: 4,
                        children: <Widget>[
                          Text(
                            buttonLabel,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lexend(
                              color: AuthColors.onLime,
                              fontWeight: FontWeight.w800,
                              fontSize: (18 * scale).clamp(16.0, 22.0),
                              letterSpacing: -0.4,
                            ),
                          ),
                          Icon(
                            Icons.sports_soccer,
                            size: (20 * scale).clamp(18.0, 24.0),
                            color: AuthColors.onLime,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: (14 * scale).clamp(12.0, 18.0)),
                  Text(
                    termsText,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.workSans(
                      color: AuthColors.outline,
                      fontSize: (10 * scale).clamp(9.0, 11.0),
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
