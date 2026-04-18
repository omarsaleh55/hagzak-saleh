import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ProfileCompletionPrivacyToggle extends StatelessWidget {
  const ProfileCompletionPrivacyToggle({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.scale,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final double scale;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final Widget toggle = GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: (48 * scale).clamp(44.0, 52.0),
        height: (24 * scale).clamp(22.0, 28.0),
        padding: EdgeInsets.symmetric(horizontal: (4 * scale).clamp(3.0, 5.0)),
        decoration: BoxDecoration(
          color: value ? AuthColors.teal : AuthColors.outlineVariant,
          borderRadius: BorderRadius.circular(999),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: (16 * scale).clamp(14.0, 18.0),
            height: (16 * scale).clamp(14.0, 18.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all((16 * scale).clamp(14.0, 20.0)),
      decoration: BoxDecoration(
        color: AuthColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular((18 * scale).clamp(14.0, 22.0)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool stack = constraints.maxWidth < 320;

          if (stack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.visibility,
                      color: AuthColors.teal,
                      size: (22 * scale).clamp(18.0, 24.0),
                    ),
                    SizedBox(width: (12 * scale).clamp(10.0, 14.0)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: GoogleFonts.workSans(
                              color: AuthColors.darkEmerald,
                              fontWeight: FontWeight.w700,
                              fontSize: (14 * scale).clamp(12.0, 16.0),
                            ),
                          ),
                          SizedBox(height: (4 * scale).clamp(3.0, 6.0)),
                          Text(
                            subtitle.toUpperCase(),
                            style: GoogleFonts.workSans(
                              color: AuthColors.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: (10 * scale).clamp(9.0, 12.0),
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: (14 * scale).clamp(10.0, 16.0)),
                Align(alignment: Alignment.centerRight, child: toggle),
              ],
            );
          }

          return Row(
            children: <Widget>[
              Icon(
                Icons.visibility,
                color: AuthColors.teal,
                size: (22 * scale).clamp(18.0, 24.0),
              ),
              SizedBox(width: (12 * scale).clamp(10.0, 14.0)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: GoogleFonts.workSans(
                        color: AuthColors.darkEmerald,
                        fontWeight: FontWeight.w700,
                        fontSize: (14 * scale).clamp(12.0, 16.0),
                      ),
                    ),
                    SizedBox(height: (4 * scale).clamp(3.0, 6.0)),
                    Text(
                      subtitle.toUpperCase(),
                      style: GoogleFonts.workSans(
                        color: AuthColors.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: (10 * scale).clamp(9.0, 12.0),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
              toggle,
            ],
          );
        },
      ),
    );
  }
}
