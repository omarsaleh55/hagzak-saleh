import 'package:flutter/material.dart';

import '../models/set_password_page_placeholder.dart';
import 'set_password_requirement_card.dart';

class SetPasswordRequirementsGrid extends StatelessWidget {
  const SetPasswordRequirementsGrid({
    super.key,
    required this.items,
    required this.scale,
  });

  final List<SetPasswordRequirementData> items;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: (8 * scale).clamp(6.0, 10.0),
      runSpacing: (8 * scale).clamp(6.0, 10.0),
      children: items
          .map(
            (SetPasswordRequirementData item) => SetPasswordRequirementCard(
              label: item.label,
              met: item.met,
              scale: scale,
            ),
          )
          .toList(),
    );
  }
}
