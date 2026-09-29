import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'service_router.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  const AnnouncementDetailScreen({super.key, required this.announcement});

  final Announcement announcement;

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState extends State<AnnouncementDetailScreen> {
  bool _reminderSet = false;

  @override
  void initState() {
    super.initState();
    // Opening an announcement marks it as read (after the first frame).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppStateScope.of(context).markRead(widget.announcement.id);
    });
  }

  String get _categoryLabel => switch (widget.announcement.category) {
    AlertCategory.academic => 'Academic',
    AlertCategory.finance => 'Finance',
    AlertCategory.facilities => 'Facilities',
    AlertCategory.transport => 'Transport',
  };

  @override
  Widget build(BuildContext context) {
    final a = widget.announcement;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement'),
        actions: [
          IconButton(
            tooltip: 'Copy announcement',
            icon: const Icon(Icons.copy_rounded),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: '${a.title}\n${a.message}\n${a.deadline}'),
              );
              if (context.mounted) {
                showCampusSnackBar(
                  context,
                  'Announcement copied to clipboard',
                  icon: Icons.copy_rounded,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF8E6), Color(0xFFFBEFD2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppStyle.cardRadius,
                  border: Border.all(color: AppColors.gold, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconTile(
                          icon: a.icon,
                          color: AppColors.navy,
                          background: AppColors.gold,
                          size: 52,
                        ),
                        const Spacer(),
                        StatusBadge(label: _categoryLabel),
                        const SizedBox(width: 6),
                        StatusBadge(label: a.badge),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      a.title,
                      style: AppStyle.heading.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      a.postedOn,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.goldDeep,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Deadline box
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.navy.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_rounded, color: AppColors.navy),
                    const SizedBox(width: 10),
                    const Text(
                      'Key date: ',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Expanded(child: Text(a.deadline)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CampusCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      a.message,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      a.details,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => openService(context, a.relatedServiceId),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(a.relatedActionLabel),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _reminderSet = !_reminderSet);
                  showCampusSnackBar(
                    context,
                    _reminderSet
                        ? 'Reminder set for ${a.deadline}'
                        : 'Reminder removed',
                    icon: _reminderSet
                        ? Icons.alarm_on_rounded
                        : Icons.alarm_off_rounded,
                  );
                },
                icon: Icon(
                  _reminderSet
                      ? Icons.alarm_on_rounded
                      : Icons.alarm_add_rounded,
                ),
                label: Text(_reminderSet ? 'Reminder set' : 'Remind me'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
