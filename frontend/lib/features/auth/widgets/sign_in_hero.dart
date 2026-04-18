import 'package:flutter/material.dart';
import '../../../core/constants/auth_colors.dart';
import '../models/auth_placeholder_data.dart';

/// Hero section — tagline + large gradient heading.
class SignInHero extends StatelessWidget {
  const SignInHero({super.key, this.scale = 1});

  final double scale;

  @override
  Widget build(BuildContext context) {
    const data = AuthPlaceholderData.signInPage;
    final brand = data['brand'] as Map<String, dynamic>;
    final hero = data['hero'] as Map<String, dynamic>;
    final double titleSize = (48 * scale).clamp(42.0, 54.0);
    final double taglineSize = (12 * scale).clamp(10.5, 13.0);

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: (122 * scale).clamp(108.0, 138.0),
            top: (-10 * scale).clamp(-14.0, -6.0),
            child: _GlowBlob(scale: scale),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                brand['tagline'] as String,
                style: TextStyle(
                  color: AuthColors.onSurface,
                  fontSize: taglineSize,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4.6 * scale,
                ),
              ),
              SizedBox(height: (14 * scale).clamp(10.0, 18.0)),
              Text(
                hero['heading_line1'] as String,
                style: TextStyle(
                  color: AuthColors.darkEmerald,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  height: 0.92,
                  letterSpacing: -2.1,
                ),
              ),
              Text(
                hero['heading_line2'] as String,
                style: TextStyle(
                  color: AuthColors.darkEmerald,
                  fontSize: titleSize,
                  fontWeight: FontWeight.w800,
                  height: 0.92,
                  letterSpacing: -2.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  const _GlowBlob({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (114 * scale).clamp(98.0, 126.0),
      height: (114 * scale).clamp(98.0, 126.0),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0x54CAF300),
      ),
    );
  }
}
