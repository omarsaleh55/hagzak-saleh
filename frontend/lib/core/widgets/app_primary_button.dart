import 'package:flutter/material.dart';
import '../constants/auth_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.scale = 1,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double radius = (20 * scale).clamp(18.0, 24.0);
    final double labelSize = (22 * scale).clamp(20.0, 24.0);
    final double iconSize = (20 * scale).clamp(18.0, 22.0);
    const Color buttonColor = AuthColors.lime;
    const Color buttonTextColor = AuthColors.onLime;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: buttonTextColor,
          elevation: 0,
          shadowColor: const Color(0x22000000),
          minimumSize: Size(double.infinity, (78 * scale).clamp(72.0, 84.0)),
          padding: EdgeInsets.symmetric(
            horizontal: (20 * scale).clamp(16.0, 24.0),
            vertical: (18 * scale).clamp(16.0, 22.0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: buttonTextColor,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: (8 * scale).clamp(6.0, 10.0)),
              Icon(icon, size: iconSize, color: buttonTextColor),
            ],
          ],
        ),
      ),
    );
  }
}
