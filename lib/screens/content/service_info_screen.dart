import 'package:flutter/material.dart';

import '../../models/campus_content.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

/// Labelled sample detail page for services without a dedicated feature.
class ServiceInfoScreen extends StatelessWidget {
  const ServiceInfoScreen({super.key, required this.service});

  final CampusService service;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.label)),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CampusCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconTile(
                      icon: service.icon,
                      color: Colors.white,
                      background: service.color,
                      size: 56,
                    ),
                    const SizedBox(height: 14),
                    Text(service.label, style: AppStyle.heading),
                    const SizedBox(height: 8),
                    Text(
                      service.description,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    InfoRow(
                      icon: Icons.place_outlined,
                      text: service.location,
                      fontSize: 14,
                    ),
                    InfoRow(
                      icon: Icons.schedule_rounded,
                      text: service.hours,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => showCampusSnackBar(
                  context,
                  'Appointment request sent to ${service.label} (demo)',
                  icon: Icons.event_available_rounded,
                ),
                icon: const Icon(Icons.event_available_rounded),
                label: const Text('Book an appointment'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Sample detail · demonstration data',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
