import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String _semester = SampleData.results.keys.first;
  bool _requested = false;

  Color _gradeColor(String grade) {
    if (grade.startsWith('A')) return AppColors.success;
    if (grade.startsWith('B')) return AppColors.info;
    return AppColors.warning;
  }

  @override
  Widget build(BuildContext context) {
    final courses = SampleData.results[_semester]!;
    final credits = courses.fold<int>(0, (s, c) => s + c.credits);
    final gpa =
        courses.fold<double>(0, (s, c) => s + c.points * c.credits) / credits;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  for (final s in SampleData.results.keys)
                    ChoiceChip(
                      label: Text(s),
                      selected: s == _semester,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: s == _semester ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _semester = s),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              // GPA summary
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1F6F6B), Color(0xFF2C8C86)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppStyle.cardRadius,
                  boxShadow: AppStyle.softShadow,
                ),
                child: Row(
                  children: [
                    _SummaryItem(
                      label: '$_semester GPA',
                      value: gpa.toStringAsFixed(2),
                    ),
                    _SummaryItem(label: 'Credits', value: '$credits'),
                    _SummaryItem(
                      label: 'CGPA',
                      value: SampleData.cgpa.toStringAsFixed(2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              for (final c in courses)
                CampusCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () => showCampusSnackBar(
                    context,
                    '${c.code}: ${c.grade} (${c.points.toStringAsFixed(2)} points × ${c.credits} credits)',
                    icon: Icons.grade_rounded,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _gradeColor(c.grade).withValues(alpha: 0.1),
                          border: Border.all(
                            color: _gradeColor(c.grade),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          c.grade,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                            color: _gradeColor(c.grade),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${c.code} · ${c.credits} credits',
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        c.points.toStringAsFixed(2),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _requested
                    ? null
                    : () {
                        setState(() => _requested = true);
                        showCampusSnackBar(
                          context,
                          'Official transcript requested – ready in 2 working days',
                          icon: Icons.description_rounded,
                        );
                      },
                icon: Icon(
                  _requested
                      ? Icons.check_circle_rounded
                      : Icons.description_rounded,
                ),
                label: Text(
                  _requested
                      ? 'Transcript requested'
                      : 'Request official transcript',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontFamilyFallback: AppStyle.serifFallback,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFFD9EFEC)),
          ),
        ],
      ),
    );
  }
}
