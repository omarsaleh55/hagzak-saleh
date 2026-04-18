import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class VerificationTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const VerificationTopBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final bool isTablet = width >= 900;
    final bool isIpad = width >= 600 && width < 900;
    final double barHeight = isTablet
        ? 70
        : isIpad
        ? 66
        : 64;
    final double horizontalPadding = isTablet
        ? 28
        : isIpad
        ? 22
        : 18;
    final double iconSize = isTablet
        ? 24
        : isIpad
        ? 22
        : 20;
    final double brandSize = isTablet
        ? 16
        : isIpad
        ? 15
        : 14;
    final double monogramSize = isTablet
        ? 22
        : isIpad
        ? 20
        : 18;

    return Semantics(
      label: title,
      child: Material(
        color: AuthColors.emerald950,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.18),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[AuthColors.emerald900, AuthColors.emerald950],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: barHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: onBack,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 20,
                          icon: Icon(
                            Icons.arrow_back,
                            color: AuthColors.lime400,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(width: isTablet ? 16 : 12),
                        Flexible(
                          child: Text(
                            title.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lexend(
                              color: AuthColors.lime400,
                              fontWeight: FontWeight.w700,
                              fontSize: brandSize,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'PP',
                      style: GoogleFonts.lexend(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: monogramSize,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
