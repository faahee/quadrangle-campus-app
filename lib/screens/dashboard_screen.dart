import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../data/sample_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/announcement_card.dart';
import '../widgets/campus_action_card.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_card.dart';
import 'events_screen.dart';
import 'home_shell.dart';
import 'service_router.dart';

/// The Student Campus App home dashboard.
///
/// Sections (top to bottom):
///  1. Header        – app identity, greeting and student profile
///  2. Academic      – CGPA, credits, attendance, advisor
///  3. Up next       – next class from the timetable
///  4. Quick access  – eight reusable CampusActionCards (responsive Wrap)
///  5. Campus update – pinned announcement
///  6. Student life  – horizontal event list + transport notice
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final pinned = SampleData.announcements.firstWhere((a) => a.pinned);
    final transport = SampleData.announcements.firstWhere(
      (a) => a.category == AlertCategory.transport,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _DashboardHeader(
              state: state,
              onBellTap: () => onOpenTab(Tabs.alerts),
              onAvatarTap: () => onOpenTab(Tabs.profile),
            ),
            SafeArea(
              top: false,
              child: ResponsiveBody(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _AcademicSnapshot(),
                    const _NextClassCard(),
                    SectionHeader(
                      title: 'Quick access',
                      actionLabel: 'See all',
                      onAction: () => onOpenTab(Tabs.services),
                    ),
                    CampusServiceGrid(
                      services: SampleData.services,
                      onServiceTap: (s) => openService(context, s.id),
                    ),
                    SectionHeader(
                      title: 'Campus update',
                      actionLabel: 'All alerts',
                      onAction: () => onOpenTab(Tabs.alerts),
                    ),
                    FeaturedAnnouncementCard(
                      announcement: pinned,
                      isRead: state.isRead(pinned.id),
                      onTap: () => openAnnouncement(context, pinned),
                    ),
                    SectionHeader(
                      title: 'Student life',
                      actionLabel: 'All events',
                      onAction: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EventsScreen()),
                      ),
                    ),
                    SizedBox(
                      height: 196,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        children: [
                          for (final event in SampleData.events)
                            EventCard(
                              event: event,
                              width: 272,
                              registered: state.isRegistered(event.id),
                              onTap: () => openEvent(context, event),
                            ),
                        ],
                      ),
                    ),
                    _TransportNotice(
                      announcement: transport,
                      onTap: () => openService(context, 'shuttle'),
                    ),
                    // Footer – alignment centres the text inside the Container.
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: const Text(
                        '${SampleData.appName} v1.0 · ${SampleData.university}\n'
                        'Prototype with sample data',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Header
// ---------------------------------------------------------------------------

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.state,
    required this.onBellTap,
    required this.onAvatarTap,
  });

  final AppState state;
  final VoidCallback onBellTap;
  final VoidCallback onAvatarTap;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    const student = SampleData.student;

    // Gradient header with rounded bottom corners and a shadow.
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative crest watermark (background pattern).
          Positioned(
            right: -30,
            top: 30,
            child: Icon(
              Icons.account_balance_rounded,
              size: 190,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 760),
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App identity row
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.gold, width: 2),
                          ),
                          child: const Icon(
                            Icons.account_balance_rounded,
                            color: AppColors.gold,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                SampleData.appName,
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontFamilyFallback: AppStyle.serifFallback,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Text(
                                '${SampleData.university} · ${SampleData.dashboardTitle}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFFCBD3E4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Notifications',
                          onPressed: onBellTap,
                          iconSize: 26,
                          color: Colors.white,
                          icon: Badge(
                            isLabelVisible: state.unreadCount > 0,
                            backgroundColor: AppColors.gold,
                            textColor: AppColors.navy,
                            label: Text('${state.unreadCount}'),
                            child: const Icon(Icons.notifications_none_rounded),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    // Student profile row
                    Row(
                      children: [
                        Semantics(
                          button: true,
                          label: 'Open profile',
                          child: GestureDetector(
                            onTap: onAvatarTap,
                            child: Container(
                              width: 76,
                              height: 76,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3A4F7A),
                                    Color(0xFF1B2B4F),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: AppColors.gold,
                                  width: 3,
                                ),
                              ),
                              child: Text(
                                student.initials,
                                style: const TextStyle(
                                  fontFamily: 'Georgia',
                                  fontFamilyFallback: AppStyle.serifFallback,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$_greeting,',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFCBD3E4),
                                ),
                              ),
                              Text(
                                state.preferredName,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${student.studentId}  |  ${student.programme}',
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFE1E6F0),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  _HeaderPill(
                                    label: student.semester.toUpperCase(),
                                    filled: true,
                                  ),
                                  _HeaderPill(label: student.yearLabel),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.label, this.filled = false});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? AppColors.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: filled ? AppColors.gold : Colors.white.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          letterSpacing: 0.8,
          fontWeight: FontWeight.w800,
          color: filled ? AppColors.navy : Colors.white,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Academic snapshot
// ---------------------------------------------------------------------------

class _AcademicSnapshot extends StatelessWidget {
  const _AcademicSnapshot();

  @override
  Widget build(BuildContext context) {
    final attendance = SampleData.overallAttendance;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: AppStyle.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Academic snapshot',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontFamilyFallback: AppStyle.serifFallback,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Semester 5 · Academic year 2026/27',
                      style: TextStyle(fontSize: 12.5, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => openService(context, 'results'),
                child: const Text('Results'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    value: SampleData.cgpa.toStringAsFixed(2),
                    label: 'CGPA',
                    progress: SampleData.cgpa / 4,
                    caption: 'of 4.00',
                    onTap: () => openService(context, 'results'),
                  ),
                ),
                const _VerticalDivider(),
                Expanded(
                  child: _StatTile(
                    value: '${SampleData.creditsEarned}',
                    label: 'Credits',
                    progress:
                        SampleData.creditsEarned / SampleData.creditsRequired,
                    caption: 'of ${SampleData.creditsRequired}',
                    onTap: () => openService(context, 'results'),
                  ),
                ),
                const _VerticalDivider(),
                Expanded(
                  child: _StatTile(
                    value: '${(attendance * 100).round()}%',
                    label: 'Attendance',
                    progress: attendance,
                    caption: 'min 80%',
                    onTap: () => openService(context, 'attendance'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _AdvisorStrip(),
        ],
      ),
    );
  }
}

/// Thin divider line – explicit width on a Container.
class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: const BoxDecoration(color: AppColors.line),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.value,
    required this.label,
    required this.progress,
    required this.caption,
    required this.onTap,
  });

  final String value;
  final String label;
  final double progress;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label $value $caption',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Georgia',
                  fontFamilyFallback: AppStyle.serifFallback,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: AppColors.parchment,
                  valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                caption,
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdvisorStrip extends StatelessWidget {
  const _AdvisorStrip();

  void _showAdvisorDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.event_available_rounded, color: AppColors.navy),
        title: const Text('Advisor appointment'),
        content: Text(
          'Your next meeting with ${SampleData.student.advisor} is on '
          '${SampleData.nextAdvisorMeeting} in Room C-310.\n\n'
          'Would you like to confirm your attendance?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Later'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              showCampusSnackBar(
                context,
                'Attendance confirmed with ${SampleData.student.advisor}',
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.15)),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => _showAdvisorDialog(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const IconTile(
                  icon: Icons.person_pin_rounded,
                  color: Colors.white,
                  background: AppColors.navy,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Advisor · ${SampleData.student.advisor}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const Text(
                        'Next meeting: ${SampleData.nextAdvisorMeeting}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.navy),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Next class
// ---------------------------------------------------------------------------

/// Finds the next class from the timetable, starting from now.
(String dayLabel, ClassSession session)? _findNextClass(DateTime now) {
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  for (var offset = 0; offset < 7; offset++) {
    final day = now.add(Duration(days: offset));
    final classes = SampleData.timetable[names[day.weekday - 1]] ?? const [];
    for (final c in classes) {
      final parts = c.start.split(':');
      final minutes = int.parse(parts[0]) * 60 + int.parse(parts[1]);
      if (offset > 0 || minutes > now.hour * 60 + now.minute) {
        final dayLabel = switch (offset) {
          0 => 'Today',
          1 => 'Tomorrow',
          _ => names[day.weekday - 1],
        };
        return (dayLabel, c);
      }
    }
  }
  return null;
}

String formatTime(String hhmm) {
  final parts = hhmm.split(':');
  var hour = int.parse(parts[0]);
  final suffix = hour >= 12 ? 'PM' : 'AM';
  if (hour > 12) hour -= 12;
  return '$hour:${parts[1]} $suffix';
}

class _NextClassCard extends StatelessWidget {
  const _NextClassCard();

  @override
  Widget build(BuildContext context) {
    final next = _findNextClass(DateTime.now());
    if (next == null) return const SizedBox.shrink();
    final (dayLabel, session) = next;

    return Container(
      margin: const EdgeInsets.only(top: 14),
      decoration: AppStyle.card(),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () => openService(context, 'timetable'),
          borderRadius: AppStyle.cardRadius,
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Gold accent bar – explicit width and height.
                Container(
                  width: 5,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UP NEXT · ${dayLabel.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w800,
                          color: AppColors.goldDeep,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${session.code} ${session.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      InfoRow(
                        icon: Icons.place_outlined,
                        text: '${session.room} · ${session.type}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 72,
                  height: 58,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.parchment,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatTime(session.start).split(' ').first,
                          style: const TextStyle(
                            fontFamily: 'Georgia',
                            fontFamilyFallback: AppStyle.serifFallback,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          formatTime(session.start).split(' ').last,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Transport notice
// ---------------------------------------------------------------------------

class _TransportNotice extends StatelessWidget {
  const _TransportNotice({required this.announcement, required this.onTap});

  final Announcement announcement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6EBDD),
        borderRadius: AppStyle.cardRadius,
        border: Border.all(
          color: const Color(0xFF8A5A1E).withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppStyle.cardRadius,
          child: Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                const IconTile(
                  icon: Icons.directions_bus_rounded,
                  color: Colors.white,
                  background: Color(0xFF8A5A1E),
                  size: 44,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Transport notice',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF5C3B10),
                              ),
                            ),
                          ),
                          StatusBadge(label: announcement.badge, compact: true),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        announcement.message,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          color: Color(0xFF6B4A1C),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8A5A1E),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
