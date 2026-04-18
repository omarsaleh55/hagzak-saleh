import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../models/sport_model.dart';
import 'sport_chip.dart';

class SportsFilterRow extends StatelessWidget {
  const SportsFilterRow({
    super.key,
    required this.sports,
    required this.selectedId,
    required this.onSelected,
  });

  final List<SportModel> sports;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pagePaddingH,
        ),
        itemCount: sports.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.sm),
        itemBuilder: (_, index) {
          final sport = sports[index];
          return SportChip(
            sport: sport,
            isSelected: selectedId == sport.id,
            onTap: () => onSelected(sport.id),
          );
        },
      ),
    );
  }
}
