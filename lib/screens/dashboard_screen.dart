import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../data/sample_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/animations.dart';
import '../widgets/announcement_card.dart';
import '../widgets/campus_action_card.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_card.dart';
import 'events_screen.dart';
import 'home_shell.dart';
import 'service_router.dart';
import 'services/fees_screen.dart' show money;

/// Width at which the dashboard switches to the two-column desktop layout.
const double kWideLayout = 1000;

/// How far the first row of cards floats up over the header.
const double _overlap = 56;

/// The Student Campus App home dashboard.
///
/// Phone / tablet: one column. Desktop (≥ 1000 px): two columns.
/// Scroll effects: parallax header, cards that float up over the header,
/// sections that reveal as they scroll into view, a sticky compact bar,
/// a campus-news marquee, count-up numbers and hover lift.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= kWideLayout;
          final maxWidth = wide ? 1180.0 : 820.0;

          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  children: [
                    _DashboardHeader(
                      state: state,
                      scroll: _scroll,
                      wide: wide,
                      maxWidth: maxWidth,
                      onBellTap: () => widget.onOpenTab(Tabs.alerts),
                      onAvatarTap: () => widget.onOpenTab(Tabs.profile),
                    ),
                    // The whole body is shifted up so the first cards float
                    // over the bottom of the header.
                    _ScrollRise(
                      scroll: _scroll,
                      child: SafeArea(
                        top: false,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                wide
                                    ? _WideBody(
                                        state: state,
                                        onOpenTab: widget.onOpenTab,
                                      )
                                    : _NarrowBody(
                                        state: state,
                                        onOpenTab: widget.onOpenTab,
                                      ),
                                const Reveal(child: _Footer()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Compact bar that fades in once the header has scrolled away.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _StickyBar(
                  scroll: _scroll,
                  maxWidth: maxWidth,
                  unread: state.unreadCount,
                  onBellTap: () => widget.onOpenTab(Tabs.alerts),
                  onTitleTap: () => _scroll.animateTo(
                    0,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Layouts
// ---------------------------------------------------------------------------

class _NarrowBody extends StatelessWidget {
  const _NarrowBody({required this.state, required this.onOpenTab});

  final AppState state;
  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final pinned = SampleData.announcements.firstWhere((a) => a.pinned);
    final transport = SampleData.announcements.firstWhere(
      (a) => a.category == AlertCategory.transport,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Reveal(child: _AcademicSnapshot()),
        const Reveal(
          delay: Duration(milliseconds: 120),
          child: _NextClassCard(margin: EdgeInsets.only(top: 14)),
        ),
        Reveal(
          delay: const Duration(milliseconds: 200),
          child: _NewsTicker(onTap: () => onOpenTab(Tabs.alerts)),
        ),
        Reveal(
          child: SectionHeader(
            title: 'Quick access',
            actionLabel: 'See all',
            onAction: () => onOpenTab(Tabs.services),
          ),
        ),
        CampusServiceGrid(
          services: SampleData.services,
          onServiceTap: (s) => openService(context, s.id),
        ),
        Reveal(
          child: SectionHeader(
            title: 'Campus update',
            actionLabel: 'All alerts',
            onAction: () => onOpenTab(Tabs.alerts),
          ),
        ),
        Reveal(
          child: FeaturedAnnouncementCard(
            announcement: pinned,
            isRead: state.isRead(pinned.id),
            onTap: () => openAnnouncement(context, pinned),
          ),
        ),
        Reveal(
          child: SectionHeader(
            title: 'Student life',
            actionLabel: 'All events',
            onAction: () => _openEvents(context),
          ),
        ),
        SizedBox(
          height: 206,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < SampleData.events.length; i++)
                Reveal(
                  from: RevealFrom.right,
                  delay: Duration(milliseconds: 90 * i),
                  child: EventCard(
                    event: SampleData.events[i],
                    width: 272,
                    registered: state.isRegistered(SampleData.events[i].id),
                    onTap: () => openEvent(context, SampleData.events[i]),
                  ),
                ),
            ],
          ),
        ),
        Reveal(
          child: _TransportNotice(
            announcement: transport,
            onTap: () => openService(context, 'shuttle'),
          ),
        ),
      ],
    );
  }
}

class _WideBody extends StatelessWidget {
  const _WideBody({required this.state, required this.onOpenTab});

  final AppState state;
  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final pinned = SampleData.announcements.firstWhere((a) => a.pinned);
    final transport = SampleData.announcements.firstWhere(
      (a) => a.category == AlertCategory.transport,
    );
    final latest = SampleData.announcements
        .where((a) => !a.pinned && a.id != transport.id)
        .take(3)
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Left column ----------
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Reveal(from: RevealFrom.left, child: _AcademicSnapshot()),
              Reveal(
                delay: const Duration(milliseconds: 200),
                child: _NewsTicker(onTap: () => onOpenTab(Tabs.alerts)),
              ),
              Reveal(
                child: SectionHeader(
                  title: 'Quick access',
                  actionLabel: 'See all',
                  onAction: () => onOpenTab(Tabs.services),
                ),
              ),
              CampusServiceGrid(
                services: SampleData.services,
                onServiceTap: (s) => openService(context, s.id),
              ),
              Reveal(
                child: SectionHeader(
                  title: 'Student life',
                  actionLabel: 'All events',
                  onAction: () => _openEvents(context),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  const gap = 14.0;
                  final w = (constraints.maxWidth - gap) / 2;
                  return Wrap(
                    spacing: gap,
                    runSpacing: gap,
                    children: [
                      for (var i = 0; i < SampleData.events.length; i++)
                        Reveal(
                          delay: Duration(milliseconds: 110 * (i % 2)),
                          child: EventCard(
                            event: SampleData.events[i],
                            width: w,
                            margin: EdgeInsets.zero,
                            registered: state.isRegistered(
                              SampleData.events[i].id,
                            ),
                            onTap: () =>
                                openEvent(context, SampleData.events[i]),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // ---------- Right column ----------
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Reveal(
                from: RevealFrom.right,
                delay: Duration(milliseconds: 120),
                child: _NextClassCard(),
              ),
              const Reveal(
                from: RevealFrom.right,
                delay: Duration(milliseconds: 220),
                child: _TodaySchedule(),
              ),
              Reveal(
                from: RevealFrom.right,
                child: SectionHeader(
                  title: 'Campus update',
                  actionLabel: 'All alerts',
                  onAction: () => onOpenTab(Tabs.alerts),
                ),
              ),
              Reveal(
                from: RevealFrom.right,
                child: FeaturedAnnouncementCard(
                  announcement: pinned,
                  isRead: state.isRead(pinned.id),
                  onTap: () => openAnnouncement(context, pinned),
                ),
              ),
              Reveal(
                from: RevealFrom.right,
                child: _TransportNotice(
                  announcement: transport,
                  onTap: () => openService(context, 'shuttle'),
                ),
              ),
              Reveal(
                from: RevealFrom.right,
                child: SectionHeader(
                  title: 'Latest alerts',
                  actionLabel: 'View all',
                  onAction: () => onOpenTab(Tabs.alerts),
                ),
              ),
              for (var i = 0; i < latest.length; i++)
                Reveal(
                  from: RevealFrom.right,
                  delay: Duration(milliseconds: 90 * i),
                  child: AnnouncementTile(
                    announcement: latest[i],
                    isRead: state.isRead(latest[i].id),
                    onTap: () => openAnnouncement(context, latest[i]),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

void _openEvents(BuildContext context) =>
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const EventsScreen()));

/// Pulls the body up over the header. The overlap starts smaller and grows
/// as the page scrolls, so the cards appear to float up over the header
/// (inspired by hero mock-ups on the web).
class _ScrollRise extends StatelessWidget {
  const _ScrollRise({required this.scroll, required this.child});

  final ScrollController scroll;
  final Widget child;

  static const double _rise = 20;

  @override
  Widget build(BuildContext context) {
    if (reduceMotion(context)) {
      return Transform.translate(
        offset: const Offset(0, -_overlap),
        child: child,
      );
    }
    return AnimatedBuilder(
      animation: scroll,
      child: child,
      builder: (context, child) {
        final offset = scroll.hasClients ? scroll.offset : 0.0;
        final t = (offset / 220).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, -_overlap + _rise * (1 - t)),
          child: child,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Header + sticky bar
// ---------------------------------------------------------------------------

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.state,
    required this.scroll,
    required this.wide,
    required this.maxWidth,
    required this.onBellTap,
    required this.onAvatarTap,
  });

  final AppState state;
  final ScrollController scroll;
  final bool wide;
  final double maxWidth;
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
    final motion = !reduceMotion(context);

    final identity = Row(
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
                style: TextStyle(fontSize: 12.5, color: Color(0xFFCBD3E4)),
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
    );

    final profile = Row(
      children: [
        Semantics(
          button: true,
          label: 'Open profile',
          child: GestureDetector(
            onTap: onAvatarTap,
            child: Floating(
              amplitude: 4,
              period: const Duration(seconds: 5),
              child: Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A4F7A), Color(0xFF1B2B4F)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: AppColors.gold, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
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
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_greeting,',
                style: const TextStyle(fontSize: 14, color: Color(0xFFCBD3E4)),
              ),
              Text(
                state.preferredName,
                style: TextStyle(
                  fontSize: wide ? 28 : 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${student.studentId}  |  ${student.programme}',
                maxLines: 2,
                style: const TextStyle(fontSize: 13, color: Color(0xFFE1E6F0)),
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
                  if (wide) _HeaderPill(label: student.faculty),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    // Gradient header with rounded bottom corners and a shadow.
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
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
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 26 + _overlap),
            child: AnimatedBuilder(
              animation: scroll,
              builder: (context, child) {
                final offset = motion && scroll.hasClients
                    ? scroll.offset
                    : 0.0;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Parallax crest watermark (background pattern).
                    Positioned(
                      right: wide ? 360 : -30,
                      top: 10 + offset * 0.5,
                      child: Floating(
                        amplitude: 8,
                        period: const Duration(seconds: 7),
                        child: Icon(
                          Icons.account_balance_rounded,
                          size: 190,
                          color: Colors.white.withValues(alpha: 0.035),
                        ),
                      ),
                    ),
                    // Content drifts down and fades while scrolling away.
                    Opacity(
                      opacity: (1 - offset / 280).clamp(0.0, 1.0),
                      child: Transform.translate(
                        offset: Offset(0, offset * 0.3),
                        child: child,
                      ),
                    ),
                  ],
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  identity,
                  const SizedBox(height: 22),
                  if (wide)
                    Row(
                      children: [
                        Expanded(child: profile),
                        const SizedBox(width: 24),
                        _HeroTodayCard(state: state),
                      ],
                    )
                  else
                    profile,
                ],
              ),
            ),
          ),
        ),
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

/// Desktop-only floating glass card in the header: "your day at a glance".
class _HeroTodayCard extends StatelessWidget {
  const _HeroTodayCard({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final day = now.weekday <= 5 ? SampleData.weekdays[now.weekday - 1] : null;
    final classes = SampleData.timetable[day]?.length ?? 0;

    Widget line(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.gold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );

    return Floating(
      amplitude: 7,
      period: const Duration(seconds: 5),
      phase: 0.3,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                width: 300,
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_weekdayNames[now.weekday - 1]}, ${now.day} ${_monthNames[now.month - 1]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Your day at a glance',
                      style: TextStyle(
                        color: Color(0xFFCBD3E4),
                        fontSize: 12.5,
                      ),
                    ),
                    line(
                      Icons.menu_book_rounded,
                      classes == 0
                          ? 'No classes today'
                          : '$classes classes today',
                    ),
                    line(
                      Icons.notifications_active_rounded,
                      '${state.unreadCount} unread alerts',
                    ),
                    line(
                      Icons.account_balance_wallet_rounded,
                      '${money(state.outstanding)} fees outstanding',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Small chip floating off the corner of the card.
          Positioned(
            right: -14,
            bottom: -18,
            child: Floating(
              amplitude: 5,
              period: const Duration(seconds: 3),
              phase: 0.6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      size: 16,
                      color: AppColors.navy,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "Dean's List eligible",
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
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

class _StickyBar extends StatelessWidget {
  const _StickyBar({
    required this.scroll,
    required this.maxWidth,
    required this.unread,
    required this.onBellTap,
    required this.onTitleTap,
  });

  final ScrollController scroll;
  final double maxWidth;
  final int unread;
  final VoidCallback onBellTap;
  final VoidCallback onTitleTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scroll,
      builder: (context, child) {
        final offset = scroll.hasClients ? scroll.offset : 0.0;
        final t = ((offset - 150) / 60).clamp(0.0, 1.0);
        return IgnorePointer(
          ignoring: t < 0.5,
          child: Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, -14 * (1 - t)),
              child: child,
            ),
          ),
        );
      },
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Align(
                child: Container(
                  height: 56,
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  padding: const EdgeInsets.only(left: 16, right: 6),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: onTitleTap,
                        child: const Row(
                          children: [
                            Icon(
                              Icons.account_balance_rounded,
                              color: AppColors.gold,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              SampleData.appName,
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontFamilyFallback: AppStyle.serifFallback,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Notifications',
                        onPressed: onBellTap,
                        color: Colors.white,
                        icon: Badge(
                          isLabelVisible: unread > 0,
                          backgroundColor: AppColors.gold,
                          textColor: AppColors.navy,
                          label: Text('$unread'),
                          child: const Icon(Icons.notifications_none_rounded),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Academic snapshot
// ---------------------------------------------------------------------------

class _AcademicSnapshot extends StatelessWidget {
  const _AcademicSnapshot();

  @override
  Widget build(BuildContext context) {
    final attendance = SampleData.overallAttendance;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: AppStyle.card().copyWith(
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
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
                    value: SampleData.cgpa,
                    decimals: 2,
                    label: 'CGPA',
                    progress: SampleData.cgpa / 4,
                    caption: 'of 4.00',
                    onTap: () => openService(context, 'results'),
                  ),
                ),
                const _VerticalDivider(),
                Expanded(
                  child: _StatTile(
                    value: SampleData.creditsEarned.toDouble(),
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
                    value: (attendance * 100).roundToDouble(),
                    suffix: '%',
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
    this.decimals = 0,
    this.suffix = '',
  });

  final double value;
  final int decimals;
  final String suffix;
  final String label;
  final double progress;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label ${value.toStringAsFixed(decimals)}$suffix $caption',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            children: [
              CountUp(
                value: value,
                decimals: decimals,
                suffix: suffix,
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
              AnimatedBar(value: progress),
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
// Campus-news marquee
// ---------------------------------------------------------------------------

class _NewsTicker extends StatelessWidget {
  const _NewsTicker({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      for (final a in SampleData.announcements)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(a.icon, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(
                a.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
    ];

    return Semantics(
      button: true,
      label: 'Campus news ticker. Open alerts',
      child: Container(
        margin: const EdgeInsets.only(top: 14),
        height: 46,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.navy, AppColors.navyLight],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppStyle.softShadow,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.campaign_rounded,
                        size: 16,
                        color: AppColors.navy,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: AppColors.navy,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Fade the text out at both edges.
                  child: ShaderMask(
                    shaderCallback: (rect) => const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white,
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: [0, 0.06, 0.92, 1],
                    ).createShader(rect),
                    blendMode: BlendMode.dstIn,
                    child: Marquee(items: items, height: 46),
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
// Next class + today's schedule
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
  const _NextClassCard({this.margin = EdgeInsets.zero});

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final next = _findNextClass(DateTime.now());
    if (next == null) return const SizedBox.shrink();
    final (dayLabel, session) = next;

    return Padding(
      padding: margin,
      child: HoverLift(
        child: Container(
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
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.parchment,
                        borderRadius: BorderRadius.circular(12),
                      ),
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
        ),
      ),
    );
  }
}

/// Desktop-only card listing today's classes as a mini timeline.
class _TodaySchedule extends StatelessWidget {
  const _TodaySchedule();

  @override
  Widget build(BuildContext context) {
    final weekday = DateTime.now().weekday;
    final isWeekend = weekday > 5;
    final day = isWeekend ? 'Mon' : SampleData.weekdays[weekday - 1];
    final classes = SampleData.timetable[day] ?? const <ClassSession>[];

    return CampusCard(
      margin: const EdgeInsets.only(top: 14),
      onTap: () => openService(context, 'timetable'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  isWeekend ? "Monday's classes" : "Today's classes",
                  style: AppStyle.heading.copyWith(fontSize: 17),
                ),
              ),
              StatusBadge(label: '${classes.length} classes', compact: true),
            ],
          ),
          if (isWeekend)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'No classes this weekend – enjoy the break!',
                style: TextStyle(fontSize: 12.5, color: AppColors.muted),
              ),
            ),
          const SizedBox(height: 10),
          for (var i = 0; i < classes.length; i++)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 64,
                  child: Text(
                    formatTime(classes[i].start),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      width: 11,
                      height: 11,
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        color: i == 0 ? AppColors.gold : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.gold, width: 2),
                      ),
                    ),
                    if (i < classes.length - 1)
                      Container(
                        width: 2,
                        height: 38,
                        decoration: const BoxDecoration(color: AppColors.line),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${classes[i].code} · ${classes[i].title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${classes[i].room} · ${classes[i].type}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transport notice + footer
// ---------------------------------------------------------------------------

class _TransportNotice extends StatelessWidget {
  const _TransportNotice({required this.announcement, required this.onTap});

  final Announcement announcement;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: HoverLift(
        child: Container(
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
                              StatusBadge(
                                label: announcement.badge,
                                compact: true,
                              ),
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
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    // Alignment centres the text inside the Container.
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: const Text(
        '${SampleData.appName} v1.0 · ${SampleData.university}\n'
        'Prototype with sample data',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: AppColors.muted),
      ),
    );
  }
}
