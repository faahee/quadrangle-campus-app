import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
String _fmt(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  void _bookRoom(BuildContext context) {
    String room = SampleData.studyRooms.first;
    String slot = SampleData.studySlots.first;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Book a study room', style: AppStyle.heading),
              const SizedBox(height: 4),
              const Text(
                'Tomorrow · 2-hour slot',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              const Text('Room', style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final r in SampleData.studyRooms)
                    ChoiceChip(
                      label: Text(r),
                      selected: r == room,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: r == room ? Colors.white : AppColors.ink,
                      ),
                      onSelected: (_) => setSheetState(() => room = r),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Start time',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in SampleData.studySlots)
                    ChoiceChip(
                      label: Text(s),
                      selected: s == slot,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: s == slot ? Colors.white : AppColors.ink,
                      ),
                      onSelected: (_) => setSheetState(() => slot = s),
                    ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    showCampusSnackBar(
                      context,
                      'Booked ${room.split(' ·').first} tomorrow at $slot',
                      icon: Icons.meeting_room_rounded,
                    );
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Confirm booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final today = DateTime(2026, 9, 29);

    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Opening hours banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFE7F4),
                  borderRadius: AppStyle.cardRadius,
                  border: Border.all(
                    color: const Color(0xFF5B3A73).withValues(alpha: 0.25),
                  ),
                ),
                child: const Row(
                  children: [
                    IconTile(
                      icon: Icons.access_time_filled_rounded,
                      color: Colors.white,
                      background: Color(0xFF5B3A73),
                      size: 44,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Main Library · Open now',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF3F2752),
                            ),
                          ),
                          Text(
                            'Mon–Fri 8:00 AM – 11:00 PM · Sat–Sun 10:00 AM – 6:00 PM',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF5B3A73),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CampusCard(
                onTap: () => _bookRoom(context),
                child: const Row(
                  children: [
                    IconTile(
                      icon: Icons.meeting_room_rounded,
                      color: AppColors.navy,
                      background: AppColors.parchment,
                      size: 44,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Book a study room',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '4 rooms available tomorrow',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.navy),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'My loans (${state.books.length})',
                style: AppStyle.heading.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 10),
              for (final b in state.books)
                Builder(
                  builder: (context) {
                    final daysLeft = b.dueDate.difference(today).inDays;
                    final left = AppState.maxRenewals - b.renewals;
                    return CampusCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          // Book spine – explicit width & height
                          Container(
                            width: 46,
                            height: 64,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF5B3A73), Color(0xFF7A5494)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  b.author,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.muted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    StatusBadge(
                                      label: daysLeft <= 5
                                          ? 'Due soon · ${_fmt(b.dueDate)}'
                                          : 'Due ${_fmt(b.dueDate)}',
                                      compact: true,
                                    ),
                                    Text(
                                      '$left renewal${left == 1 ? '' : 's'} left',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: left == 0
                                ? null
                                : () {
                                    state.renewBook(b);
                                    showCampusSnackBar(
                                      context,
                                      'Renewed "${b.title}" until ${_fmt(b.dueDate)}',
                                      icon: Icons.autorenew_rounded,
                                    );
                                  },
                            child: const Text('Renew'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
