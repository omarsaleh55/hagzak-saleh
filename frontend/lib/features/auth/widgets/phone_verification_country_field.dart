import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationCountryField extends StatelessWidget {
  const PhoneVerificationCountryField({
    super.key,
    required this.value,
    required this.scale,
  });

  final String value;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (48 * scale).clamp(46.0, 56.0),
      padding: EdgeInsets.symmetric(horizontal: (12 * scale).clamp(11.0, 16.0)),
      decoration: BoxDecoration(
        color: AuthColors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular((8 * scale).clamp(8.0, 12.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lexend(
                color: AuthColors.darkEmerald,
                fontWeight: FontWeight.w600,
                fontSize: (11.6 * scale).clamp(11.0, 15.5),
              ),
            ),
          ),
          SizedBox(width: 4 * scale),
          Icon(
            Icons.expand_more,
            color: AuthColors.outline,
            size: (16 * scale).clamp(14.0, 18.0),
          ),
        ],
      ),
    );
  }
}
