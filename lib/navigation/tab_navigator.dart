import 'package:flutter/material.dart';

import 'app_routes.dart';

/// A [Navigator] widget for one bottom-navigation tab.
///
/// Each tab owns its own page stack, so opening a service keeps the floating
/// nav bar on screen and switching tabs returns you to where you left off.
class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.root,
  });

  final GlobalKey<NavigatorState> navigatorKey;

  /// First page of the tab (its `/` route).
  final Widget root;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: Navigator.defaultRouteName,
      onGenerateRoute: (settings) =>
          AppRoutes.onGenerateRoute(settings, home: root),
    );
  }
}
