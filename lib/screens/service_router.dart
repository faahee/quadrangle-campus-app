import 'package:flutter/material.dart';

import '../data/models.dart';
import 'announcement_detail_screen.dart';
import 'event_detail_screen.dart';
import 'services/attendance_screen.dart';
import 'services/clubs_screen.dart';
import 'services/fees_screen.dart';
import 'services/helpdesk_screen.dart';
import 'services/library_screen.dart';
import 'services/results_screen.dart';
import 'services/shuttle_screen.dart';
import 'services/timetable_screen.dart';

/// Central place that opens the right page for each campus service.
void openService(BuildContext context, String serviceId) {
  final Widget page = switch (serviceId) {
    'timetable' => const TimetableScreen(),
    'results' => const ResultsScreen(),
    'attendance' => const AttendanceScreen(),
    'fees' => const FeesScreen(),
    'library' => const LibraryScreen(),
    'shuttle' => const ShuttleScreen(),
    'clubs' => const ClubsScreen(),
    _ => const HelpdeskScreen(),
  };
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

void openAnnouncement(BuildContext context, Announcement announcement) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => AnnouncementDetailScreen(announcement: announcement),
    ),
  );
}

void openEvent(BuildContext context, CampusEvent event) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => EventDetailScreen(event: event)));
}
