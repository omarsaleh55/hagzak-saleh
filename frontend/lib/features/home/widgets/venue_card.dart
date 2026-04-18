import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/buttons/primary_button.dart';
import '../models/venue_model.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    super.key,
    required this.venue,
    required this.onTap,
    required this.onBookTap,
  });

  final VenueModel venue;
  final VoidCallback onTap;
  final VoidCallback onBookTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.venueCardWidth,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VenueImage(imageUrl: venue.imageUrl, sport: venue.sport),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: AppTextStyles.headingSm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  _VenueMeta(city: venue.city, distanceKm: venue.distanceKm),
                  const SizedBox(height: AppDimensions.xs),
                  _VenueRating(
                    rating: venue.rating,
                    reviewCount: venue.reviewCount,
                  ),
                  const SizedBox(height: AppDimensions.md),
                  _VenuePriceRow(
                    pricePerHour: venue.pricePerHour,
                    onBookTap: onBookTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueImage extends StatelessWidget {
  const _VenueImage({required this.imageUrl, required this.sport});

  final String imageUrl;
  final String sport;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusLg),
          ),
          child: Image.network(
            imageUrl,
            width: double.infinity,
            height: AppDimensions.featuredImageHeight,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: AppDimensions.featuredImageHeight,
              color: AppColors.surfaceVariant,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textHint,
                size: 32,
              ),
            ),
          ),
        ),
        Positioned(
          top: AppDimensions.sm,
          left: AppDimensions.sm,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.sm,
              vertical: AppDimensions.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Text(
              sport,
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VenueMeta extends StatelessWidget {
  const _VenueMeta({required this.city, required this.distanceKm});

  final String city;
  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 12,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Text(
            '$city · ${distanceKm.toStringAsFixed(1)} ${AppStrings.kmAway}',
            style: AppTextStyles.bodySm,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _VenueRating extends StatelessWidget {
  const _VenueRating({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 14, color: AppColors.star),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.labelSm.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(width: AppDimensions.xs),
        Text('($reviewCount)', style: AppTextStyles.bodySm),
      ],
    );
  }
}

class _VenuePriceRow extends StatelessWidget {
  const _VenuePriceRow({required this.pricePerHour, required this.onBookTap});

  final double pricePerHour;
  final VoidCallback onBookTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${AppStrings.egp} ${pricePerHour.toStringAsFixed(0)}',
                  style: AppTextStyles.headingSm.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const TextSpan(
                  text: AppStrings.perHour,
                  style: AppTextStyles.bodySm,
                ),
              ],
            ),
          ),
        ),
        PrimaryButton(
          label: AppStrings.bookNow,
          onPressed: onBookTap,
          isFullWidth: false,
          height: AppDimensions.cardButtonHeight,
        ),
      ],
    );
  }
}
