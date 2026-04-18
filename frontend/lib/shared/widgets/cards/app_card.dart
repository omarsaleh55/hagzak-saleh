import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.radius,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius ?? AppDimensions.radiusLg;

    return Material(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(effectiveRadius),
            border: Border.all(color: borderColor ?? AppColors.border),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
