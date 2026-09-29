import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../dashboard_screen.dart' show formatTime;

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late String _day;
  final Set<String> _reminders = {};

  static const _dates = {
    'Mon': '28',
    'Tue': '29',
    'Wed': '30',
    'Thu': '1',
    'Fri': '2',
  };

  @override
  void initState() {
    super.initState();
    final weekday = DateTime.now().weekday; // 1 = Mon … 7 = Sun
    _day = weekday <= 5 ? SampleData.weekdays[weekday - 1] : 'Mon';
  }

  Color _typeColor(String type) => switch (type) {
    'Lab' => const Color(0xFF1F6F6B),
    'Tutorial' => const Color(0xFF5B3A73),
    'Studio' => const Color(0xFF8A5A1E),
    _ => AppColors.info,
  };

  void _showClass(ClassSession c) {
    final key = '$_day-${c.code}-${c.start}';
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBadge(label: c.type),
            const SizedBox(height: 10),
            Text('${c.code} · ${c.title}', style: AppStyle.heading),
            const SizedBox(height: 12),
            InfoRow(
              icon: Icons.schedule_rounded,
              text: '$_day, ${formatTime(c.start)} – ${formatTime(c.end)}',
              fontSize: 14,
            ),
            InfoRow(icon: Icons.place_outlined, text: c.room, fontSize: 14),
            InfoRow(
              icon: Icons.person_outline_rounded,
              text: c.lecturer,
              fontSize: 14,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final on = !_reminders.contains(key);
                  setState(
                    () => on ? _reminders.add(key) : _reminders.remove(key),
                  );
                  Navigator.pop(sheetContext);
                  showCampusSnackBar(
                    context,
                    on
                        ? 'Reminder set 15 min before ${c.code}'
                        : 'Reminder removed for ${c.code}',
                    icon: on ? Icons.alarm_on_rounded : Icons.alarm_off_rounded,
                  );
                },
                icon: Icon(
                  _reminders.contains(key)
                      ? Icons.alarm_off_rounded
                      : Icons.alarm_add_rounded,
                ),
                label: Text(
                  _reminders.contains(key)
                      ? 'Remove reminder'
                      : 'Remind me 15 min before',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final classes = SampleData.timetable[_day] ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Timetable')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Week 5 · 28 Sep – 2 Oct 2026',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 10),
              // Day selector – selected day animates to navy.
              Row(
                children: [
                  for (final d in SampleData.weekdays)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _day = d),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 64,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: d == _day ? AppColors.navy : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: d == _day
                                  ? AppColors.navy
                                  : AppColors.line,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                d,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: d == _day
                                      ? const Color(0xFFCBD3E4)
                                      : AppColors.muted,
                                ),
                              ),
                              Text(
                                _dates[d]!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: d == _day
                                      ? AppColors.gold
                                      : AppColors.navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '${classes.length} classes on $_day',
                style: AppStyle.heading.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 10),
              for (final c in classes)
                CampusCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () => _showClass(c),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.parchment,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              c.start,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppColors.navy,
                              ),
                            ),
                            const Text(
                              'to',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                            Text(
                              c.end,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  c.code,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: _typeColor(c.type),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _typeColor(c.type)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    c.type,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: _typeColor(c.type),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (_reminders.contains(
                                  '$_day-${c.code}-${c.start}',
                                ))
                                  const Icon(
                                    Icons.alarm_on_rounded,
                                    size: 18,
                                    color: AppColors.gold,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              c.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            InfoRow(icon: Icons.place_outlined, text: c.room),
                            InfoRow(
                              icon: Icons.person_outline_rounded,
                              text: c.lecturer,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
