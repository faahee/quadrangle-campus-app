import 'package:flutter/material.dart';

import '../state/app_state.dart';
import 'alerts_screen.dart';
import 'dashboard_screen.dart';
import 'profile_screen.dart';
import 'services_screen.dart';

/// Holds the four main tabs and the bottom navigation bar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  void _goTo(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final unread = AppStateScope.of(context).unreadCount;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          DashboardScreen(onOpenTab: _goTo),
          const ServicesScreen(),
          const AlertsScreen(),
          ProfileScreen(onOpenTab: _goTo),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'Services',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_rounded),
            ),
            label: 'Alerts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
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
