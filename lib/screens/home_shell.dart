import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/quick_actions_sheet.dart';
import 'alerts_screen.dart';
import 'dashboard_screen.dart';
import 'events_screen.dart';
import 'profile_screen.dart';
import 'service_router.dart';
import 'services_screen.dart';

/// Holds the four main tabs and the floating bottom navigation bar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  bool _navVisible = true;
  bool _actionsOpen = false;

  static const _destinations = [
    NavDestinationData('Home', Icons.home_outlined, Icons.home_rounded),
    NavDestinationData(
      'Services',
      Icons.grid_view_outlined,
      Icons.grid_view_rounded,
    ),
    NavDestinationData(
      'Alerts',
      Icons.notifications_outlined,
      Icons.notifications_rounded,
    ),
    NavDestinationData(
      'Profile',
      Icons.person_outline_rounded,
      Icons.person_rounded,
    ),
  ];

  void _goTo(int index) => setState(() {
    _index = index;
    _navVisible = true;
  });

  /// Hide the bar while scrolling down, bring it back when scrolling up.
  bool _onScroll(UserScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    final show = switch (n.direction) {
      ScrollDirection.reverse => false,
      ScrollDirection.forward => true,
      // Always show the bar again once back at the very top.
      ScrollDirection.idle => _navVisible || n.metrics.pixels <= 0,
    };
    if (show != _navVisible) setState(() => _navVisible = show);
    return false;
  }

  Future<void> _openQuickActions() async {
    setState(() => _actionsOpen = true);
    await showQuickActionsSheet(context, [
      QuickAction(
        'Pay fees',
        Icons.account_balance_wallet_rounded,
        AppColors.danger,
        AppColors.dangerTint,
        () => openService(context, 'fees'),
      ),
      QuickAction(
        'Book a study room',
        Icons.meeting_room_rounded,
        const Color(0xFF5B3A73),
        const Color(0xFFEFE7F4),
        () => openService(context, 'library'),
      ),
      QuickAction(
        'New helpdesk ticket',
        Icons.support_agent_rounded,
        const Color(0xFF37516B),
        const Color(0xFFE5ECF2),
        () => openService(context, 'helpdesk'),
      ),
      QuickAction(
        'Today\'s timetable',
        Icons.calendar_month_rounded,
        AppColors.info,
        AppColors.infoTint,
        () => openService(context, 'timetable'),
      ),
      QuickAction(
        'Browse events',
        Icons.celebration_rounded,
        AppColors.goldDeep,
        AppColors.parchment,
        () =>
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const EventsScreen())),
      ),
      QuickAction(
        'Digital ID',
        Icons.badge_rounded,
        AppColors.navy,
        AppColors.mist,
        () => showDigitalIdDialog(context),
      ),
    ]);
    if (mounted) setState(() => _actionsOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final unread = AppStateScope.of(context).unreadCount;

    return Scaffold(
      extendBody: true,
      body: NotificationListener<UserScrollNotification>(
        onNotification: _onScroll,
        child: IndexedStack(
          index: _index,
          children: [
            DashboardScreen(onOpenTab: _goTo),
            const ServicesScreen(),
            const AlertsScreen(),
            ProfileScreen(onOpenTab: _goTo),
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavBar(
        destinations: _destinations,
        selectedIndex: _index,
        onSelected: _goTo,
        onCenterTap: _openQuickActions,
        centerOpen: _actionsOpen,
        visible: _navVisible,
        badges: {Tabs.alerts: unread},
      ),
    );
  }
}

/// Tab indexes, so other screens can switch tabs by name.
class Tabs {
  static const int home = 0;
  static const int services = 1;
  static const int alerts = 2;
  static const int profile = 3;
}
