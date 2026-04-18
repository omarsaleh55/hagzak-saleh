import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/auth_colors.dart';

class ProfileCompletionAvatarSection extends StatelessWidget {
  const ProfileCompletionAvatarSection({
    super.key,
    required this.title,
    required this.description,
    required this.scale,
    required this.onPressed,
    this.imageBytes,
    this.networkImageUrl,
    this.isLoading = false,
    this.statusText,
    this.statusColor,
  });

  final String title;
  final String description;
  final double scale;
  final VoidCallback onPressed;
  final Uint8List? imageBytes;

  /// URL of a remote image (e.g. Google profile photo). Shown when
  /// [imageBytes] is null and the user has not yet picked a local photo.
  final String? networkImageUrl;
  final bool isLoading;
  final String? statusText;
  final Color? statusColor;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = (80 * scale).clamp(68.0, 96.0);
    final double radius = (12 * scale).clamp(10.0, 16.0);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stackVertically = constraints.maxWidth < 320;

        final Widget avatarCard = Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isLoading ? null : onPressed,
                borderRadius: BorderRadius.circular(radius),
                child: Ink(
                  width: avatarSize,
                  height: avatarSize,
                  decoration: BoxDecoration(
                    color: AuthColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: AuthColors.outlineVariant,
                      width: (2 * scale).clamp(1.5, 2.5),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius - 1),
                    child: imageBytes != null
                        ? Image.memory(imageBytes!, fit: BoxFit.cover)
                        : networkImageUrl != null
                        ? Image.network(
                            networkImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Icon(
                              Icons.add_a_photo_outlined,
                              color: AuthColors.outline,
                              size: (30 * scale).clamp(24.0, 34.0),
                            ),
                          )
                        : Icon(
                            Icons.add_a_photo_outlined,
                            color: AuthColors.outline,
                            size: (30 * scale).clamp(24.0, 34.0),
                          ),
                  ),
                ),
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: (-6 * scale).clamp(-8.0, -4.0),
              bottom: (-6 * scale).clamp(-8.0, -4.0),
              child: IgnorePointer(
                child: Container(
                  padding: EdgeInsets.all((6 * scale).clamp(4.0, 8.0)),
                  decoration: BoxDecoration(
                    color: AuthColors.lime,
                    borderRadius: BorderRadius.circular(
                      (8 * scale).clamp(6.0, 10.0),
                    ),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: AuthColors.limeGlow,
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.edit,
                    color: AuthColors.onLime,
                    size: (14 * scale).clamp(12.0, 16.0),
                  ),
                ),
              ),
            ),
          ],
        );

        final Widget textBlock = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.lexend(
                color: AuthColors.darkEmerald,
                fontWeight: FontWeight.w600,
                fontSize: (18 * scale).clamp(16.0, 22.0),
              ),
            ),
            SizedBox(height: (6 * scale).clamp(4.0, 8.0)),
            Text(
              description,
              style: GoogleFonts.workSans(
                color: AuthColors.onSurfaceVariant,
                fontSize: (14 * scale).clamp(12.0, 16.0),
                height: 1.35,
              ),
            ),
            if (statusText != null && statusText!.isNotEmpty) ...<Widget>[
              SizedBox(height: (6 * scale).clamp(4.0, 8.0)),
              Text(
                statusText!,
                style: GoogleFonts.workSans(
                  color: statusColor ?? AuthColors.teal,
                  fontSize: (12 * scale).clamp(11.0, 14.0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        );

        if (stackVertically) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              avatarCard,
              SizedBox(height: (18 * scale).clamp(14.0, 22.0)),
              textBlock,
            ],
          );
        }

        return Row(
          children: <Widget>[
            avatarCard,
            SizedBox(width: (20 * scale).clamp(16.0, 24.0)),
            Expanded(child: textBlock),
          ],
        );
      },
    );
  }
}
