import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  static const double minimum = 0.8;

  void _showDetails(BuildContext context, AttendanceRecord r) {
    final absences = r.total - r.attended;
    // Classes you could still miss (with 28 sessions in the semester) and stay ≥ 80%.
    const semesterSessions = 28;
    final canMiss = (semesterSessions * (1 - minimum)).floor() - absences;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(r.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${r.code} · ${(r.ratio * 100).round()}% attendance'),
            const SizedBox(height: 10),
            Text('Attended: ${r.attended} of ${r.total} sessions'),
            Text('Absences: $absences'),
            const SizedBox(height: 10),
            Text(
              canMiss > 0
                  ? 'You can miss $canMiss more session${canMiss == 1 ? '' : 's'} and stay above 80%.'
                  : 'You must attend every remaining session to meet the 80% rule.',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: canMiss > 0 ? AppColors.success : AppColors.danger,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              showCampusSnackBar(
                context,
                'Medical certificate upload opened for ${r.code} (demo)',
                icon: Icons.upload_file_rounded,
              );
            },
            child: const Text('Submit MC'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final overall = SampleData.overallAttendance;
    final atRisk = SampleData.attendance.where((r) => r.ratio < minimum).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CampusCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Circular progress ring with explicit size.
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: overall,
                            strokeWidth: 10,
                            backgroundColor: AppColors.parchment,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.success,
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              '${(overall * 100).round()}%',
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontFamilyFallback: AppStyle.serifFallback,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overall attendance',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Semester 5 · minimum required 80%',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 10),
                          StatusBadge(
                            label: atRisk == 0
                                ? 'Good standing'
                                : '$atRisk course below 80%',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              for (final r in SampleData.attendance)
                CampusCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () => _showDetails(context, r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${r.code} · ${r.attended}/${r.total} sessions',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${(r.ratio * 100).round()}%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: r.ratio < minimum
                                  ? AppColors.danger
                                  : AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: r.ratio,
                          minHeight: 8,
                          backgroundColor: AppColors.parchment,
                          valueColor: AlwaysStoppedAnimation(
                            r.ratio < minimum
                                ? AppColors.danger
                                : AppColors.success,
                          ),
                        ),
                      ),
                      if (r.ratio < minimum) ...[
                        const SizedBox(height: 8),
                        const StatusBadge(
                          label: 'Below 80% – attendance warning',
                          compact: true,
                        ),
                      ],
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
