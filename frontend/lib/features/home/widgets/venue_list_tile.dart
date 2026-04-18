import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/venue_model.dart';

class VenueListTile extends StatelessWidget {
  const VenueListTile({super.key, required this.venue, required this.onTap});

  final VenueModel venue;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _TileImage(imageUrl: venue.imageUrl),
            const SizedBox(width: AppDimensions.md),
            Expanded(child: _TileInfo(venue: venue)),
            _TilePrice(pricePerHour: venue.pricePerHour),
          ],
        ),
      ),
    );
  }
}

class _TileImage extends StatelessWidget {
  const _TileImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Image.network(
        imageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: 72,
          height: 72,
          color: AppColors.surfaceVariant,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }
}

class _TileInfo extends StatelessWidget {
  const _TileInfo({required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venue.name,
          style: AppTextStyles.headingSm,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppDimensions.xs),
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 12,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                '${venue.city} · ${venue.distanceKm.toStringAsFixed(1)} ${AppStrings.kmAway}',
                style: AppTextStyles.bodySm,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.xs),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 13, color: AppColors.star),
            const SizedBox(width: 2),
            Text(
              '${venue.rating.toStringAsFixed(1)} (${venue.reviewCount})',
              style: AppTextStyles.bodySm,
            ),
            const SizedBox(width: AppDimensions.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Text(
                venue.sport,
                style: AppTextStyles.bodySm.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TilePrice extends StatelessWidget {
  const _TilePrice({required this.pricePerHour});

  final double pricePerHour;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${AppStrings.egp} ${pricePerHour.toStringAsFixed(0)}',
          style: AppTextStyles.headingSm.copyWith(color: AppColors.primary),
        ),
        const Text(AppStrings.perHour, style: AppTextStyles.bodySm),
      ],
    );
  }
}
