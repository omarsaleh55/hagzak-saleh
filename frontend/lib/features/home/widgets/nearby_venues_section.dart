import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/feedback/empty_state_widget.dart';
import '../../../shared/widgets/layout/section_header.dart';
import '../models/venue_model.dart';
import 'venue_list_tile.dart';

class NearbyVenuesSection extends StatelessWidget {
  const NearbyVenuesSection({
    super.key,
    required this.venues,
    required this.onVenueTap,
    this.onSeeAll,
  });

  final List<VenueModel> venues;
  final ValueChanged<VenueModel> onVenueTap;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.pagePaddingH,
          ),
          child: SectionHeader(
            title: AppStrings.nearbyVenues,
            onSeeAll: onSeeAll,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        if (venues.isEmpty)
          const EmptyStateWidget(
            title: AppStrings.noVenuesFound,
            subtitle: AppStrings.tryDifferentSearch,
            icon: Icons.location_off_outlined,
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.pagePaddingH,
            ),
            itemCount: venues.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppDimensions.sm),
            itemBuilder: (_, index) => VenueListTile(
              venue: venues[index],
              onTap: () => onVenueTap(venues[index]),
            ),
          ),
      ],
    );
  }
}
