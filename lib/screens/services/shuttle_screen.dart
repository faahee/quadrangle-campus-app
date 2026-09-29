import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ShuttleScreen extends StatefulWidget {
  const ShuttleScreen({super.key});

  @override
  State<ShuttleScreen> createState() => _ShuttleScreenState();
}

class _ShuttleScreenState extends State<ShuttleScreen> {
  final _random = Random();
  late Map<String, List<int>> _eta;
  String? _expanded;

  @override
  void initState() {
    super.initState();
    _eta = _generateEtas();
  }

  /// Random "live" arrival times for the next three buses on each route.
  Map<String, List<int>> _generateEtas() => {
    for (final r in SampleData.shuttleRoutes)
      r.id: () {
        final first = 1 + _random.nextInt(9);
        final gap = switch (r.id) {
          'A' => 10,
          'B' => 20,
          'C' => 30,
          _ => 15,
        };
        return [first, first + gap, first + gap * 2];
      }(),
  };

  void _refresh() {
    setState(() => _eta = _generateEtas());
    showCampusSnackBar(
      context,
      'Live shuttle times updated',
      icon: Icons.refresh_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus shuttle'),
        actions: [
          IconButton(
            tooltip: 'Refresh live times',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ResponsiveBody(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.warningTint,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.35),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.warning,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Route B is diverted via East Ring Road from 5–12 Oct. '
                          'Board at the temporary stop outside the Sports Complex.',
                          style: TextStyle(fontSize: 13, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                ),
                for (final r in SampleData.shuttleRoutes)
                  _RouteCard(
                    route: r,
                    etas: _eta[r.id]!,
                    expanded: _expanded == r.id,
                    alertOn: state.hasShuttleAlert(r.id),
                    onToggleExpand: () => setState(
                      () => _expanded = _expanded == r.id ? null : r.id,
                    ),
                    onToggleAlert: () {
                      final on = state.toggleShuttleAlert(r.id);
                      showCampusSnackBar(
                        context,
                        on
                            ? 'We\'ll notify you 5 min before the next ${r.id} bus'
                            : 'Arrival alerts off for ${r.name}',
                        icon: on
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_off_rounded,
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.etas,
    required this.expanded,
    required this.alertOn,
    required this.onToggleExpand,
    required this.onToggleAlert,
  });

  final ShuttleRoute route;
  final List<int> etas;
  final bool expanded;
  final bool alertOn;
  final VoidCallback onToggleExpand;
  final VoidCallback onToggleAlert;

  @override
  Widget build(BuildContext context) {
    return CampusCard(
      padding: const EdgeInsets.all(14),
      onTap: onToggleExpand,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: route.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  route.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${route.from} to ${route.to}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: alertOn ? 'Turn off arrival alert' : 'Notify me',
                onPressed: onToggleAlert,
                icon: Icon(
                  alertOn
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: alertOn ? AppColors.gold : AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              StatusBadge(label: route.status, compact: true),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  route.frequency,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < etas.length; i++)
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: i < etas.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == 0
                          ? route.color.withValues(alpha: 0.1)
                          : AppColors.ivory,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: i == 0
                            ? route.color.withValues(alpha: 0.4)
                            : AppColors.line,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${etas[i]} min',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: i == 0 ? route.color : AppColors.ink,
                          ),
                        ),
                        Text(
                          i == 0 ? 'Next bus' : 'Then',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 12),
            const Text(
              'Stops',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 6),
            for (var i = 0; i < route.stops.length; i++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == 0 || i == route.stops.length - 1
                              ? route.color
                              : Colors.white,
                          border: Border.all(color: route.color, width: 2),
                        ),
                      ),
                      if (i < route.stops.length - 1)
                        Container(width: 2, height: 16, color: route.color),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i < route.stops.length - 1 ? 16 : 0,
                    ),
                    child: Text(
                      route.stops[i],
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
          ] else
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Tap to see all stops',
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ),
        ],
      ),
    );
  }
}
