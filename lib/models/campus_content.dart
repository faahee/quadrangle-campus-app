import 'package:flutter/material.dart';

/// Lab models for the Announcements list and Services grid.
///
/// Every item has a stable [id], so bookmarks never depend on list positions.
/// All content below is demonstration data.

class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.preview,
    required this.detail,
  });

  final String id, title, category, date, preview, detail;
}

/// Where a service tile leads: an existing app feature (service page) or a
/// labelled sample information page.
enum ServiceDestination { feature, info }

class CampusService {
  const CampusService({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.description,
    required this.destination,
    this.featureId,
    this.location = '',
    this.hours = '',
  });

  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final String description;
  final ServiceDestination destination;

  /// Existing app service opened when [destination] is `feature`
  /// (e.g. `library`, `requests`).
  final String? featureId;
  final String location;
  final String hours;
}
