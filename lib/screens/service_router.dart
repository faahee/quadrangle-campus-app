import 'package:flutter/material.dart';

import '../data/models.dart';
import '../navigation/app_routes.dart';

/// Small helpers so screens can open pages without knowing route names.
/// Each one pushes onto the nearest [Navigator] – normally the current tab's.

void openService(BuildContext context, String serviceId) =>
    Navigator.of(context).pushNamed(AppRoutes.service, arguments: serviceId);

void openAnnouncement(BuildContext context, Announcement announcement) =>
    Navigator.of(context)
        .pushNamed(AppRoutes.announcement, arguments: announcement);

void openEvent(BuildContext context, CampusEvent event) =>
    Navigator.of(context).pushNamed(AppRoutes.event, arguments: event);

void openEvents(BuildContext context) =>
    Navigator.of(context).pushNamed(AppRoutes.events);

void openAnnouncements(BuildContext context) =>
    Navigator.of(context).pushNamed(AppRoutes.announcements);

void openSupportServices(BuildContext context) =>
    Navigator.of(context).pushNamed(AppRoutes.supportServices);

void openRequestForm(BuildContext context) =>
    Navigator.of(context).pushNamed(AppRoutes.newRequest);
