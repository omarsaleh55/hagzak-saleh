import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/feedback/loading_shimmer.dart';
import '../../../shared/widgets/layout/section_header.dart';
import '../models/venue_model.dart';
import 'venue_card.dart';

class FeaturedVenuesSection extends StatelessWidget {
  const FeaturedVenuesSection({
    super.key,
    required this.venues,
    required this.isLoading,
    required this.onVenueTap,
    required this.onBookTap,
    this.onSeeAll,
  });

  final List<VenueModel> venues;
  final bool isLoading;
  final ValueChanged<VenueModel> onVenueTap;
  final ValueChanged<VenueModel> onBookTap;
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
            title: AppStrings.featuredVenues,
            onSeeAll: onSeeAll,
          ),
        ),
        const SizedBox(height: AppDimensions.md),
        SizedBox(
          height: AppDimensions.venueCardHeight,
          child: isLoading
              ? _ShimmerList()
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.pagePaddingH,
                  ),
                  itemCount: venues.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppDimensions.md),
                  itemBuilder: (_, index) => VenueCard(
                    venue: venues[index],
                    onTap: () => onVenueTap(venues[index]),
                    onBookTap: () => onBookTap(venues[index]),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.pagePaddingH,
      ),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(width: AppDimensions.md),
      itemBuilder: (_, _) => const VenueCardShimmer(),
    );
  }
}
