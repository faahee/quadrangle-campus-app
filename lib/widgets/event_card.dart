import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

/// Reusable student-life event card (date tile, title, time, venue, status).
class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
    required this.registered,
    required this.onTap,
    this.width,
    this.margin = const EdgeInsets.only(right: 12, bottom: 6),
  });

  final CampusEvent event;
  final bool registered;
  final VoidCallback onTap;
  final double? width;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${event.title}, ${event.day} ${event.month}, ${event.venue}',
      child: Container(
        width: width,
        margin: margin,
        decoration: AppStyle.card(),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppStyle.cardRadius,
            child: Container(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DateTile(
                        day: event.day,
                        month: event.month,
                        color: event.color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 11,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w700,
                                color: event.color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.25,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  InfoRow(icon: Icons.schedule_rounded, text: event.time),
                  InfoRow(icon: Icons.place_outlined, text: event.venue),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Flexible(
                        child: StatusBadge(
                          label: registered
                              ? 'Registered'
                              : event.seatsLeft <= 10
                              ? 'Few seats left'
                              : 'Open',
                          compact: true,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Spacer(),
                      Text(
                        'View event',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: event.color,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: event.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
