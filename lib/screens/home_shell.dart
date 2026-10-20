import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../state/app_state.dart';
import '../navigation/app_routes.dart';
import '../navigation/tab_navigator.dart';
import '../theme/app_theme.dart';
import '../widgets/floating_nav_bar.dart';
import '../widgets/quick_actions_sheet.dart';
import 'alerts_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'services_screen.dart';

/// The app's main [Scaffold]: four tabs (each with its own [Navigator])
/// and the floating bottom navigation bar.
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

  /// One navigator per tab, so each tab keeps its own page history.
  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  NavigatorState get _currentNavigator => _navigatorKeys[_index].currentState!;

  void _selectTab(int index) {
    if (index == _index) {
      // Tapping the active tab again returns to its first page.
      _currentNavigator.popUntil((route) => route.isFirst);
    }
    _goTo(index);
  }

  /// Android back button: go back inside the current tab first, then to Home.
  void _handleBack() {
    if (_currentNavigator.canPop()) {
      _currentNavigator.maybePop();
    } else if (_index != Tabs.home) {
      _goTo(Tabs.home);
    } else {
      SystemNavigator.pop();
    }
  }

  Future<void> _openQuickActions() async {
    setState(() => _actionsOpen = true);
    void push(String route, [Object? arguments]) =>
        _currentNavigator.pushNamed(route, arguments: arguments);

    await showQuickActionsSheet(context, [
      QuickAction(
        'New request',
        Icons.edit_note_rounded,
        AppColors.abyss,
        AppColors.flame.withValues(alpha: 0.35),
        () => push(AppRoutes.newRequest),
      ),
      QuickAction(
        'Pay fees',
        Icons.account_balance_wallet_rounded,
        AppColors.truffle,
        AppColors.dangerTint,
        () => push(AppRoutes.service, 'fees'),
      ),
      QuickAction(
        'Book a study room',
        Icons.meeting_room_rounded,
        AppColors.abyss,
        AppColors.mist,
        () => push(AppRoutes.service, 'library'),
      ),
      QuickAction(
        'Today\'s timetable',
        Icons.calendar_month_rounded,
        AppColors.navy,
        AppColors.infoTint,
        () => push(AppRoutes.service, 'timetable'),
      ),
      QuickAction(
        'Browse events',
        Icons.celebration_rounded,
        AppColors.warning,
        AppColors.warningTint,
        () => push(AppRoutes.events),
      ),
      QuickAction(
        'Digital ID',
        Icons.badge_rounded,
        AppColors.navy,
        AppColors.parchment,
        () => showDigitalIdDialog(context),
      ),
    ]);
    if (mounted) setState(() => _actionsOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    final unread = AppStateScope.of(context).unreadCount;
    final roots = [
      DashboardScreen(onOpenTab: _goTo),
      const ServicesScreen(),
      const AlertsScreen(),
      ProfileScreen(onOpenTab: _goTo),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        extendBody: true,
        body: NotificationListener<UserScrollNotification>(
          onNotification: _onScroll,
          child: IndexedStack(
            index: _index,
            children: [
              for (var i = 0; i < roots.length; i++)
                TabNavigator(navigatorKey: _navigatorKeys[i], root: roots[i]),
            ],
          ),
        ),
        bottomNavigationBar: FloatingNavBar(
          destinations: _destinations,
          selectedIndex: _index,
          onSelected: _selectTab,
          onCenterTap: _openQuickActions,
          centerOpen: _actionsOpen,
          visible: _navVisible,
          badges: {Tabs.alerts: unread},
        ),
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
