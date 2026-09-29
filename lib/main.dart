import 'dart:ui';

import 'package:flutter/material.dart';

import 'data/sample_data.dart';
import 'screens/home_shell.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const QuadrangleApp());
}

/// Root widget: MaterialApp + shared app state.
class QuadrangleApp extends StatefulWidget {
  const QuadrangleApp({super.key});

  @override
  State<QuadrangleApp> createState() => _QuadrangleAppState();
}

class _QuadrangleAppState extends State<QuadrangleApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: _state,
      child: MaterialApp(
        title: SampleData.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        scrollBehavior: const _AppScrollBehavior(),
        home: const HomeShell(),
      ),
    );
  }
}

/// Lets mouse and trackpad drags scroll lists too (useful on web/desktop).
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}
