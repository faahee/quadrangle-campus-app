import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/sample_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/announcement_card.dart';
import '../widgets/common_widgets.dart';
import 'service_router.dart';

/// "Alerts" tab – all campus announcements with filters.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  String _filter = 'All';

  static const _filters = [
    'All',
    'Unread',
    'Academic',
    'Finance',
    'Facilities',
    'Transport',
  ];

  bool _matches(Announcement a, AppState state) => switch (_filter) {
    'Unread' => !state.isRead(a.id),
    'Academic' => a.category == AlertCategory.academic,
    'Finance' => a.category == AlertCategory.finance,
    'Facilities' => a.category == AlertCategory.facilities,
    'Transport' => a.category == AlertCategory.transport,
    _ => true,
  };

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final items = SampleData.announcements
        .where((a) => _matches(a, state))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus alerts'),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            onPressed: state.unreadCount == 0
                ? null
                : () {
                    state.markAllRead();
                    showCampusSnackBar(context, 'All alerts marked as read');
                  },
            icon: const Icon(Icons.done_all_rounded),
            label: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ResponsiveBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Summary banner
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.navy, AppColors.navyLight],
                    ),
                    borderRadius: AppStyle.cardRadius,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.notifications_active_rounded,
                        color: AppColors.gold,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.unreadCount == 0
                              ? "You're all caught up!"
                              : 'You have ${state.unreadCount} unread alert${state.unreadCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final f = _filters[i];
                      final selected = f == _filter;
                      return ChoiceChip(
                        label: Text(f),
                        selected: selected,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) => setState(() => _filter = f),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  const EmptyState(
                    icon: Icons.mark_email_read_rounded,
                    message: 'Nothing here – no alerts match this filter.',
                  )
                else
                  for (final a in items)
                    AnnouncementTile(
                      announcement: a,
                      isRead: state.isRead(a.id),
                      onTap: () => openAnnouncement(context, a),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
