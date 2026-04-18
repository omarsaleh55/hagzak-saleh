import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/auth_colors.dart';

bool get _mapsSupported =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

/// Interactive Google Map card that shows the selected pin or a default Cairo
/// view. Tapping the card invokes [onTap] (used to open the full map picker).
class ProfileCompletionMapCard extends StatelessWidget {
  const ProfileCompletionMapCard({
    super.key,
    required this.badgeText,
    required this.scale,
    this.latitude,
    this.longitude,
    this.onTap,
  });

  final String badgeText;
  final double scale;
  final double? latitude;
  final double? longitude;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Default to Cairo centre when no location is selected.
    final double lat = latitude ?? 30.0444;
    final double lng = longitude ?? 31.2357;
    final LatLng target = LatLng(lat, lng);
    final bool hasLocation = latitude != null && longitude != null;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double cardHeight = width >= 620
            ? 180
            : width >= 460
            ? 150
            : (width * 0.38).clamp(120.0, 150.0);

        return GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular((18 * scale).clamp(14.0, 22.0)),
            child: SizedBox(
              height: cardHeight,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // ── Map preview (non-interactive) ────────────────────
                  if (_mapsSupported)
                    IgnorePointer(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: target,
                          zoom: hasLocation ? 15 : 11,
                        ),
                        markers: hasLocation
                            ? <Marker>{
                                Marker(
                                  markerId: const MarkerId('preview'),
                                  position: target,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueGreen,
                                  ),
                                ),
                              }
                            : <Marker>{},
                        liteModeEnabled: true,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        mapToolbarEnabled: false,
                        scrollGesturesEnabled: false,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                      ),
                    )
                  else
                    const ColoredBox(color: AuthColors.surfaceContainerHighest),

                  // Tint overlay
                  Container(
                    color: AuthColors.darkEmerald.withValues(alpha: 0.15),
                  ),

                  // ── Centre icon (if no pin) ─────────────────────────
                  if (!hasLocation)
                    Positioned.fill(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: (42 * scale).clamp(34.0, 52.0),
                              height: (42 * scale).clamp(34.0, 52.0),
                              decoration: BoxDecoration(
                                color: AuthColors.lime.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_location_alt,
                                color: AuthColors.darkEmerald,
                                size: (22 * scale).clamp(18.0, 28.0),
                              ),
                            ),
                            SizedBox(height: (6 * scale).clamp(4.0, 8.0)),
                            Text(
                              'Tap to pick location',
                              style: GoogleFonts.workSans(
                                color: AuthColors.surfaceContainerLowest,
                                fontWeight: FontWeight.w600,
                                fontSize: (11 * scale).clamp(10.0, 13.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // ── Badge ───────────────────────────────────────────
                  Positioned(
                    right: (8 * scale).clamp(8.0, 12.0),
                    bottom: (8 * scale).clamp(8.0, 12.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: (8 * scale).clamp(6.0, 10.0),
                        vertical: (6 * scale).clamp(4.0, 8.0),
                      ),
                      decoration: BoxDecoration(
                        color: AuthColors.darkEmerald.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(
                          (6 * scale).clamp(5.0, 8.0),
                        ),
                      ),
                      child: Text(
                        badgeText.toUpperCase(),
                        style: GoogleFonts.workSans(
                          color: AuthColors.surfaceContainerLowest,
                          fontWeight: FontWeight.w700,
                          fontSize: (9 * scale).clamp(8.0, 10.0),
                          letterSpacing: 1.0 * scale,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
