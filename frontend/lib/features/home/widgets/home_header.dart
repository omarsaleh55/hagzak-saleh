import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/buttons/app_icon_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onAvatarTap,
    this.avatarUrl,
  });

  final String userName;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onAvatarTap;
  final String? avatarUrl;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryLight,
            backgroundImage: avatarUrl != null
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null
                ? Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : '?',
                    style: AppTextStyles.headingMd.copyWith(
                      color: AppColors.primary,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_greeting, style: AppTextStyles.bodySm),
              Text(
                userName,
                style: AppTextStyles.headingMd,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: Icons.notifications_outlined,
          onPressed: onNotificationTap ?? () {},
          badge: notificationCount,
        ),
      ],
    );
  }
}
