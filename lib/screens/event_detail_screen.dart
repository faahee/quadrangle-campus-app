import 'package:flutter/material.dart';

import '../data/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key, required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final registered = state.isRegistered(event.id);
    final seats = event.seatsLeft - (registered ? 1 : 0);

    return Scaffold(
      appBar: AppBar(title: Text(event.category)),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero banner in the event's colour
              Container(
                height: 170,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [event.color, event.color.withValues(alpha: 0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppStyle.cardRadius,
                  boxShadow: AppStyle.softShadow,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -20,
                      child: Icon(
                        event.icon,
                        size: 140,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        DateTile(
                          day: event.day,
                          month: event.month,
                          color: event.color,
                          size: 68,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontFamily: 'Georgia',
                                  fontFamilyFallback: AppStyle.serifFallback,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.organiser,
                                style: const TextStyle(
                                  color: Color(0xFFE9ECF3),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              CampusCard(
                child: Column(
                  children: [
                    _DetailLine(
                      icon: Icons.calendar_today_rounded,
                      label: 'Date',
                      value:
                          '${event.weekday}, ${event.day} ${event.month} 2026',
                    ),
                    _DetailLine(
                      icon: Icons.schedule_rounded,
                      label: 'Time',
                      value: event.time,
                    ),
                    _DetailLine(
                      icon: Icons.place_rounded,
                      label: 'Venue',
                      value: event.venue,
                    ),
                    _DetailLine(
                      icon: Icons.event_seat_rounded,
                      label: 'Seats left',
                      value: '$seats',
                    ),
                  ],
                ),
              ),
              CampusCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About this event',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: const TextStyle(fontSize: 14, height: 1.55),
                    ),
                  ],
                ),
              ),
              // Status strip changes colour when registered
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: registered ? AppColors.successTint : AppColors.mist,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: registered
                        ? AppColors.success.withValues(alpha: 0.4)
                        : AppColors.info.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      registered
                          ? Icons.verified_rounded
                          : Icons.info_outline_rounded,
                      color: registered ? AppColors.success : AppColors.info,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        registered
                            ? 'You are registered. Show your student ID at the entrance.'
                            : 'Registration is free for Kingsbridge students.',
                        style: const TextStyle(fontSize: 13.5),
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: registered
                      ? AppColors.danger
                      : AppColors.navy,
                ),
                onPressed: () {
                  final nowRegistered = state.toggleEvent(event.id);
                  showCampusSnackBar(
                    context,
                    nowRegistered
                        ? 'Registered for ${event.title}!'
                        : 'Registration cancelled',
                    icon: nowRegistered
                        ? Icons.celebration_rounded
                        : Icons.event_busy_rounded,
                  );
                },
                icon: Icon(
                  registered
                      ? Icons.event_busy_rounded
                      : Icons.how_to_reg_rounded,
                ),
                label: Text(
                  registered ? 'Cancel registration' : 'Register now',
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => showCampusSnackBar(
                  context,
                  'Added "${event.title}" to your calendar',
                  icon: Icons.event_available_rounded,
                ),
                icon: const Icon(Icons.edit_calendar_rounded),
                label: const Text('Add to calendar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          IconTile(
            icon: icon,
            color: AppColors.navy,
            background: AppColors.parchment,
            size: 36,
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 84,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
