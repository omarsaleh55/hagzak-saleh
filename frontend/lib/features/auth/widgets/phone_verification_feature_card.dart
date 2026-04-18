import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';
import '../models/phone_verification_page_placeholder.dart';

class PhoneVerificationFeatureCard extends StatelessWidget {
  const PhoneVerificationFeatureCard({
    super.key,
    required this.data,
    required this.scale,
    this.minHeight,
  });

  final PhoneVerificationFeatureData data;
  final double scale;
  final double? minHeight;

  IconData _mapIcon(String iconKey) {
    switch (iconKey) {
      case 'verified_user':
        return Icons.verified_user;
      case 'bolt':
        return Icons.bolt;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: EdgeInsets.all((12 * scale).clamp(11.0, 16.0)),
      decoration: BoxDecoration(
        color: const Color(0xFFECEEED),
        borderRadius: BorderRadius.circular((10 * scale).clamp(8.0, 14.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            _mapIcon(data.icon),
            color: AuthColors.darkEmerald,
            size: (16 * scale).clamp(14.0, 20.0),
          ),
          SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
          Text(
            data.title.toUpperCase(),
            style: GoogleFonts.workSans(
              color: AuthColors.darkEmerald,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5 * scale,
              fontSize: (9 * scale).clamp(8.0, 11.5),
            ),
          ),
          SizedBox(height: (4 * scale).clamp(3.0, 6.0)),
          Text(
            data.description,
            style: GoogleFonts.workSans(
              color: AuthColors.onSurfaceVariant,
              height: 1.22,
              fontSize: (9.2 * scale).clamp(8.0, 12.0),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
