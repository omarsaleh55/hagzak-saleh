import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PhoneVerificationTopBar({
    super.key,
    required this.title,
    required this.scale,
    required this.onBack,
  });

  final String title;
  final double scale;
  final VoidCallback onBack;

  @override
  Size get preferredSize => Size.fromHeight((44 * scale).clamp(36.0, 58.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FA),
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: (40 * scale).clamp(34.0, 54.0),
      leadingWidth: (34 * scale).clamp(30.0, 48.0),
      leading: IconButton(
        onPressed: onBack,
        padding: EdgeInsets.only(left: 2 * scale),
        icon: Icon(
          Icons.arrow_back,
          color: AuthColors.emeraldDeep,
          size: (18 * scale).clamp(16.0, 24.0),
        ),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: GoogleFonts.lexend(
          fontSize: (14.5 * scale).clamp(12.0, 20.0),
          fontWeight: FontWeight.w600,
          color: AuthColors.emeraldDeep,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Color(0xFFD8DDDD)),
      ),
    );
  }
}
