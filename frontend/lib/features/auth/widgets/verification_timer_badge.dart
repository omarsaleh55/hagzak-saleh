import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class VerificationTimerBadge extends StatelessWidget {
  const VerificationTimerBadge({
    super.key,
    required this.prefix,
    required this.value,
  });

  final String prefix;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AuthColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.timer_outlined,
            size: 10,
            color: AuthColors.darkEmerald,
          ),
          const SizedBox(width: 4),
          Text(
            '$prefix $value'.toUpperCase(),
            style: GoogleFonts.workSans(
              color: AuthColors.darkEmerald,
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
