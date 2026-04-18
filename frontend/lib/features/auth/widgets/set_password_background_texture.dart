import 'package:flutter/material.dart';

class SetPasswordBackgroundTexture extends StatelessWidget {
  const SetPasswordBackgroundTexture({
    super.key,
    required this.imageUrl,
    required this.width,
  });

  final String imageUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: Opacity(
            opacity: 0.03,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
