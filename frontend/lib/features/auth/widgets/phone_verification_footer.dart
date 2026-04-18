import 'package:flutter/material.dart';

import '../../../core/constants/auth_colors.dart';

class PhoneVerificationFooter extends StatelessWidget {
  const PhoneVerificationFooter({
    super.key,
    required this.imageUrl,
    required this.height,
  });

  final String imageUrl;
  final double height;

  static const List<double> _grayscaleBrightnessMatrix = <double>[
    0.1063,
    0.3576,
    0.0361,
    0,
    0,
    0.1063,
    0.3576,
    0.0361,
    0,
    0,
    0.1063,
    0.3576,
    0.0361,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(color: AuthColors.surfaceContainerHighest),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    AuthColors.surfaceContainerHighest,
                    AuthColors.surface,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: 12,
            child: Opacity(
              opacity: 0.34,
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix(
                  _grayscaleBrightnessMatrix,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  loadingBuilder:
                      (
                        BuildContext context,
                        Widget child,
                        ImageChunkEvent? loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const _PhoneVerificationFooterFallback();
                      },
                  errorBuilder: (_, _, _) =>
                      const _PhoneVerificationFooterFallback(),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 14,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFE5E7E7),
                  border: Border(
                    bottom: BorderSide(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: <Color>[
                  AuthColors.surface,
                  Color(0xB8F8F9FA),
                  Color(0x40F8F9FA),
                  Color(0x00F8F9FA),
                ],
                stops: <double>[0.0, 0.34, 0.72, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneVerificationFooterFallback extends StatelessWidget {
  const _PhoneVerificationFooterFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AuthColors.surfaceContainerHighest,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              widthFactor: 1.2,
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.9),
                    radius: 1.1,
                    colors: <Color>[
                      Colors.white.withValues(alpha: 0.45),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 28,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Colors.white.withValues(alpha: 0.16),
                    Colors.white.withValues(alpha: 0.02),
                    Colors.white.withValues(alpha: 0.16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
