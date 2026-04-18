import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';
import '../../../core/constants/egypt_governorates.dart';
import 'profile_completion_field_label.dart';

/// A styled, searchable dropdown for Egyptian governorates.
///
/// Tapping the field opens a modal bottom sheet with a search bar and a
/// scrollable list of governorates filtered in real-time.
class ProfileCompletionGovernorateField extends StatelessWidget {
  const ProfileCompletionGovernorateField({
    super.key,
    required this.label,
    required this.selectedGovernorate,
    required this.scale,
    this.onChanged,
    this.errorText,
  });

  final String label;
  final String? selectedGovernorate;
  final double scale;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final double radius = (12 * scale).clamp(10.0, 16.0);
    final bool hasValue =
        selectedGovernorate != null && selectedGovernorate!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProfileCompletionFieldLabel(text: label, scale: scale),
        SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
        GestureDetector(
          onTap: () => _openGovernorateSheet(context),
          child: Container(
            constraints: BoxConstraints(
              minHeight: (56 * scale).clamp(52.0, 66.0),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: (16 * scale).clamp(14.0, 20.0),
              vertical: (16 * scale).clamp(14.0, 18.0),
            ),
            decoration: BoxDecoration(
              color: AuthColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(radius),
              border: errorText != null
                  ? Border.all(
                      color: Colors.red.shade400,
                      width: (1.1 * scale).clamp(1.0, 1.6),
                    )
                  : null,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.location_city,
                  color: hasValue ? AuthColors.teal : AuthColors.outline,
                  size: (22 * scale).clamp(18.0, 24.0),
                ),
                SizedBox(width: (12 * scale).clamp(8.0, 14.0)),
                Expanded(
                  child: Text(
                    hasValue ? selectedGovernorate! : 'Select governorate',
                    style: GoogleFonts.workSans(
                      color: hasValue
                          ? AuthColors.onSurface
                          : AuthColors.onSurfaceVariant.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                      fontSize: (15 * scale).clamp(13.0, 18.0),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AuthColors.outline,
                  size: (24 * scale).clamp(20.0, 28.0),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...<Widget>[
          SizedBox(height: (6 * scale).clamp(4.0, 8.0)),
          Padding(
            padding: EdgeInsets.only(left: (4 * scale).clamp(2.0, 6.0)),
            child: Text(
              errorText!,
              style: GoogleFonts.workSans(
                color: Colors.red.shade700,
                fontSize: (11 * scale).clamp(10.0, 13.0),
                height: 1.25,
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _openGovernorateSheet(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return _GovernorateSearchSheet(
          current: selectedGovernorate,
          scale: scale,
        );
      },
    ).then((String? value) {
      if (value != null && onChanged != null) {
        onChanged!(value);
      }
    });
  }
}

// ─── Bottom-sheet with search ───────────────────────────────────────────────

class _GovernorateSearchSheet extends StatefulWidget {
  const _GovernorateSearchSheet({required this.current, required this.scale});

  final String? current;
  final double scale;

  @override
  State<_GovernorateSearchSheet> createState() =>
      _GovernorateSearchSheetState();
}

class _GovernorateSearchSheetState extends State<_GovernorateSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filtered = EgyptGovernorates.all;

  void _onSearch(String query) {
    final String q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = EgyptGovernorates.all;
      } else {
        _filtered = EgyptGovernorates.all
            .where((String g) => g.toLowerCase().contains(q))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double maxSheetHeight = screenHeight * 0.7;

    return Container(
      constraints: BoxConstraints(maxHeight: maxSheetHeight),
      decoration: const BoxDecoration(
        color: AuthColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // ── Drag handle ────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AuthColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Select Governorate',
              style: GoogleFonts.workSans(
                color: AuthColors.onSurface,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Search field ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: GoogleFonts.workSans(
                color: AuthColors.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: 'Search governorate…',
                hintStyle: GoogleFonts.workSans(
                  color: AuthColors.onSurfaceVariant.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AuthColors.teal,
                  size: 22,
                ),
                filled: true,
                fillColor: AuthColors.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AuthColors.teal,
                    width: 1.2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // ── List ───────────────────────────────────────────────────
          Flexible(
            child: _filtered.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Text(
                      'No governorate found.',
                      style: GoogleFonts.workSans(
                        color: AuthColors.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 20),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 2),
                    itemBuilder: (BuildContext ctx, int i) {
                      final String gov = _filtered[i];
                      final bool isSelected = gov == widget.current;
                      return ListTile(
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: isSelected
                            ? AuthColors.lime.withValues(alpha: 0.12)
                            : null,
                        leading: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected
                              ? AuthColors.teal
                              : AuthColors.outlineVariant,
                          size: 22,
                        ),
                        title: Text(
                          gov,
                          style: GoogleFonts.workSans(
                            color: AuthColors.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () => Navigator.pop(ctx, gov),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
