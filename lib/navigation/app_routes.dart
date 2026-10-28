import 'package:flutter/material.dart';

import '../data/models.dart';
import '../screens/announcement_detail_screen.dart';
import '../screens/content/announcements_screen.dart';
import '../screens/content/support_services_screen.dart';
import '../screens/event_detail_screen.dart';
import '../screens/events_screen.dart';
import '../screens/request_form_screen.dart';
import '../screens/services/attendance_screen.dart';
import '../screens/services/clubs_screen.dart';
import '../screens/services/fees_screen.dart';
import '../screens/services/library_screen.dart';
import '../screens/services/requests_screen.dart';
import '../screens/services/results_screen.dart';
import '../screens/services/shuttle_screen.dart';
import '../screens/services/timetable_screen.dart';

/// Named routes used by every [Navigator] in the app.
///
/// Pages are opened with `Navigator.pushNamed(context, AppRoutes.x,
/// arguments: …)` and built here in one place.
class AppRoutes {
  AppRoutes._();

  static const String service = '/service'; // arguments: service id
  static const String announcement = '/announcement'; // arguments: Announcement
  static const String event = '/event'; // arguments: CampusEvent
  static const String events = '/events';
  static const String newRequest = '/requests/new';
  static const String announcements = '/announcements';
  static const String supportServices = '/support-services';

  /// Builds the page for [settings]. [home] is the page for the initial `/`
  /// route of a tab's navigator.
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings, {
    Widget? home,
  }) {
    final Widget? page = switch (settings.name) {
      Navigator.defaultRouteName => home,
      service => _servicePage(settings.arguments as String),
      announcement => AnnouncementDetailScreen(
        announcement: settings.arguments as Announcement,
      ),
      event => EventDetailScreen(event: settings.arguments as CampusEvent),
      events => const EventsScreen(),
      newRequest => const RequestFormScreen(),
      announcements => const AnnouncementsScreen(),
      supportServices => const SupportServicesScreen(),
      _ => null,
    };
    if (page == null) return null;
    return MaterialPageRoute<dynamic>(settings: settings, builder: (_) => page);
  }

  static Widget _servicePage(String id) => switch (id) {
    'timetable' => const TimetableScreen(),
    'results' => const ResultsScreen(),
    'attendance' => const AttendanceScreen(),
    'fees' => const FeesScreen(),
    'library' => const LibraryScreen(),
    'shuttle' => const ShuttleScreen(),
    'clubs' => const ClubsScreen(),
    _ => const RequestsScreen(),
  };
}
