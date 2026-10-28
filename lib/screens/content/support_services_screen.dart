import 'package:flutter/material.dart';

import '../../data/campus_content_data.dart';
import '../../models/campus_content.dart';
import '../../theme/app_theme.dart';
import '../service_router.dart';
import 'service_info_screen.dart';

/// Responsive grid of six campus support services.
/// 2 columns on phones, 3 from 420 px, 4 from 700 px.
class SupportServicesScreen extends StatelessWidget {
  const SupportServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const services = CampusContentData.services;
    final textScale = MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 2.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Student services')),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 700
                  ? 4
                  : constraints.maxWidth >= 420
                  ? 3
                  : 2;
              return GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  24 + MediaQuery.paddingOf(context).bottom,
                ),
                itemCount: services.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  // Height = padding + icon + gap + two label lines at the
                  // current text size, so labels never clip.
                  mainAxisExtent: 24 + 48 + 10 + 2 * 14 * 1.35 * textScale + 16,
                ),
                itemBuilder: (context, index) =>
                    ServiceTile(service: services[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.service});

  final CampusService service;

  void _open(BuildContext context) {
    if (service.destination == ServiceDestination.feature) {
      openService(context, service.featureId!);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ServiceInfoScreen(service: service)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open ${service.label}',
      excludeSemantics: true,
      child: Material(
        color: service.color.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: AppStyle.cardRadius,
          side: BorderSide(color: service.color.withValues(alpha: 0.25)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _open(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: service.color,
                  child: Icon(service.icon, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  service.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: service.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
