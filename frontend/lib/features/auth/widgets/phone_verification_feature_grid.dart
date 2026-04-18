import 'package:flutter/material.dart';

import '../models/phone_verification_page_placeholder.dart';
import 'phone_verification_feature_card.dart';

class PhoneVerificationFeatureGrid extends StatelessWidget {
  const PhoneVerificationFeatureGrid({
    super.key,
    required this.items,
    required this.scale,
  });

  final List<PhoneVerificationFeatureData> items;
  final double scale;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double spacing = (12 * scale).clamp(10.0, 18.0);
        final bool singleColumn = constraints.maxWidth < 280;

        if (singleColumn) {
          return Column(
            children: List<Widget>.generate(items.length, (int index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == items.length - 1 ? 0 : spacing,
                ),
                child: PhoneVerificationFeatureCard(
                  data: items[index],
                  scale: scale,
                  minHeight: (88 * scale).clamp(82.0, 112.0),
                ),
              );
            }),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List<Widget>.generate(items.length, (int index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == items.length - 1 ? 0 : spacing,
                ),
                child: PhoneVerificationFeatureCard(
                  data: items[index],
                  scale: scale,
                  minHeight: (98 * scale).clamp(92.0, 124.0),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
