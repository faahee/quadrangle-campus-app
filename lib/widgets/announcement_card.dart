import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

/// Highlighted announcement used on the dashboard ("Campus update").
/// Gold tint + gold border make it stand out from the white cards.
class FeaturedAnnouncementCard extends StatelessWidget {
  const FeaturedAnnouncementCard({
    super.key,
    required this.announcement,
    required this.isRead,
    required this.onTap,
  });

  final Announcement announcement;
  final bool isRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Announcement: ${announcement.title}. Tap to view details.',
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF8E6), Color(0xFFFBEFD2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppStyle.cardRadius,
          border: Border.all(color: AppColors.gold, width: 1.2),
          boxShadow: AppStyle.softShadow,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppStyle.cardRadius,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const IconTile(
                        icon: Icons.campaign_rounded,
                        color: AppColors.navy,
                        background: AppColors.gold,
                        size: 50,
                      ),
                      if (!isRead)
                        Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (announcement.pinned)
                              const StatusBadge(label: 'Pinned', compact: true),
                            StatusBadge(
                              label: announcement.badge,
                              compact: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          announcement.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A3A08),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          announcement.message,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.35,
                            color: Color(0xFF5E4B12),
                          ),
                        ),
                        const SizedBox(height: 8),
                        InfoRow(
                          icon: Icons.schedule_rounded,
                          text: 'Deadline: ${announcement.deadline}',
                          color: AppColors.goldDeep,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap to view details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.goldDeep,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.goldDeep,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact announcement row used in the Alerts tab.
class AnnouncementTile extends StatelessWidget {
  const AnnouncementTile({
    super.key,
    required this.announcement,
    required this.isRead,
    required this.onTap,
  });

  final Announcement announcement;
  final bool isRead;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CampusCard(
      onTap: onTap,
      color: isRead ? AppColors.surface : const Color(0xFFFFFCF4),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            icon: announcement.icon,
            color: isRead ? AppColors.muted : AppColors.navy,
            background: isRead ? AppColors.mist : AppColors.parchment,
            size: 44,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        announcement.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isRead
                              ? FontWeight.w600
                              : FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    if (!isRead)
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  announcement.message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    StatusBadge(label: announcement.badge, compact: true),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        announcement.deadline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
