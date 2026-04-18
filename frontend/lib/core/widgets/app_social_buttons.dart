import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/auth_colors.dart';

class _BaseSocialButton extends StatelessWidget {
  const _BaseSocialButton({
    required this.onPressed,
    required this.label,
    required this.iconWidget,
    required this.scale,
  });

  final VoidCallback onPressed;
  final String label;
  final Widget iconWidget;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double radius = (16 * scale).clamp(14.0, 18.0);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          constraints: BoxConstraints(
            minHeight: (76 * scale).clamp(70.0, 82.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: (20 * scale).clamp(18.0, 24.0),
            vertical: (18 * scale).clamp(16.0, 20.0),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: const Color(0xFFF1F3F1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  iconWidget,
                  SizedBox(width: (18 * scale).clamp(16.0, 20.0)),
                  Text(
                    label,
                    style: TextStyle(
                      color: AuthColors.onSurface,
                      fontSize: (18 * scale).clamp(16.0, 20.0),
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFFD4D8D6),
                size: (28 * scale).clamp(24.0, 30.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppGoogleButton extends StatelessWidget {
  const AppGoogleButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.scale = 1,
  });

  final VoidCallback onPressed;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return _BaseSocialButton(
      onPressed: onPressed,
      label: label,
      iconWidget: SvgPicture.asset(
        'assets/icons/google.svg',
        width: (22 * scale).clamp(20.0, 24.0),
        height: (22 * scale).clamp(20.0, 24.0),
      ),
      scale: scale,
    );
  }
}

class AppAppleButton extends StatelessWidget {
  const AppAppleButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.scale = 1,
  });

  final VoidCallback onPressed;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return _BaseSocialButton(
      onPressed: onPressed,
      label: label,
      iconWidget: FaIcon(
        FontAwesomeIcons.apple,
        size: (24 * scale).clamp(22.0, 28.0),
      ),
      scale: scale,
    );
  }
}
