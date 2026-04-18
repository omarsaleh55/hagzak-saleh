import 'dart:async';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/auth_colors.dart';

bool get _mapsSupported =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

/// Data class returned by [LocationPickerPage] via `Navigator.pop`.
class PickedLocation {
  const PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

/// Full-screen Google Maps page that lets the user pick a location by tapping.
class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  /// If non-null, the map opens centered on this position.
  final double? initialLatitude;
  final double? initialLongitude;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  // Default centre: Cairo, Egypt
  static const LatLng _cairoCenter = LatLng(30.0444, 31.2357);

  GoogleMapController? _mapController;
  LatLng _selectedPosition = _cairoCenter;
  String _addressText = 'Tap on the map to pick a location';
  bool _isLoadingAddress = false;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedPosition = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
      _reverseGeocode(_selectedPosition);
    } else {
      _goToCurrentLocation(animate: false);
    }
  }

  // ── Location permission + GPS ──────────────────────────────────────────────

  Future<void> _goToCurrentLocation({bool animate = true}) async {
    setState(() => _isLocating = true);
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack('Location permission was denied.');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showSnack('Location permission is permanently denied.');
        return;
      }

      final Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final LatLng newPos = LatLng(pos.latitude, pos.longitude);
      setState(() => _selectedPosition = newPos);
      _reverseGeocode(newPos);

      if (animate && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newPos, zoom: 16),
          ),
        );
      }
    } catch (e) {
      _showSnack('Could not determine your location.');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  // ── Reverse geocode ────────────────────────────────────────────────────────

  Timer? _debounce;

  Future<void> _reverseGeocode(LatLng pos) async {
    _debounce?.cancel();
    setState(() => _isLoadingAddress = true);

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        final List<Placemark> placemarks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );
        if (placemarks.isNotEmpty && mounted) {
          final Placemark p = placemarks.first;
          final String parts = <String>[
            if (p.street != null && p.street!.isNotEmpty) p.street!,
            if (p.subLocality != null && p.subLocality!.isNotEmpty)
              p.subLocality!,
            if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
            if (p.administrativeArea != null &&
                p.administrativeArea!.isNotEmpty)
              p.administrativeArea!,
          ].join(', ');
          setState(
            () => _addressText = parts.isNotEmpty ? parts : 'Unknown location',
          );
        }
      } catch (_) {
        if (mounted) {
          setState(
            () => _addressText =
                '${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}',
          );
        }
      } finally {
        if (mounted) setState(() => _isLoadingAddress = false);
      }
    });
  }

  // ── Map callbacks ──────────────────────────────────────────────────────────

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng pos) {
    setState(() => _selectedPosition = pos);
    _reverseGeocode(pos);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _confirmLocation() {
    Navigator.pop<PickedLocation>(
      context,
      PickedLocation(
        latitude: _selectedPosition.latitude,
        longitude: _selectedPosition.longitude,
        address: _addressText,
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final double safeTop = MediaQuery.paddingOf(context).top;
    final double safeBottom = MediaQuery.paddingOf(context).bottom;

    if (!_mapsSupported) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pick Location')),
        body: const Center(
          child: Text('Map is not supported on this platform.'),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // ── Google Map ──────────────────────────────────────────────
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _selectedPosition,
              zoom: 14,
            ),
            onTap: _onMapTap,
            markers: <Marker>{
              Marker(
                markerId: const MarkerId('selected'),
                position: _selectedPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // ── Top bar ─────────────────────────────────────────────────
          Positioned(
            top: safeTop + 8,
            left: 16,
            right: 16,
            child: Row(
              children: <Widget>[
                _CircleButton(
                  icon: Icons.arrow_back,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AuthColors.darkEmerald.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      'Pick Your Pitch Location',
                      style: GoogleFonts.workSans(
                        color: AuthColors.lime,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _CircleButton(
                  icon: Icons.my_location,
                  isLoading: _isLocating,
                  onTap: () => _goToCurrentLocation(),
                ),
              ],
            ),
          ),

          // ── Bottom address card + confirm button ────────────────────
          Positioned(
            left: 16,
            right: 16,
            bottom: safeBottom + 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Address card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AuthColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AuthColors.lime.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: AuthColors.teal,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _isLoadingAddress
                            ? Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AuthColors.teal,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Getting address…',
                                    style: GoogleFonts.workSans(
                                      color: AuthColors.onSurfaceVariant,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                _addressText,
                                style: GoogleFonts.workSans(
                                  color: AuthColors.onSurface,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.5,
                                  height: 1.35,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Confirm button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AuthColors.lime,
                      foregroundColor: AuthColors.onLime,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'CONFIRM LOCATION',
                      style: GoogleFonts.workSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }
}

// ── Helper widget ───────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AuthColors.surfaceContainerLowest,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AuthColors.teal,
                ),
              )
            : Icon(icon, color: AuthColors.darkEmerald, size: 22),
      ),
    );
  }
}
