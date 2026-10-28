import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../theme/app_theme.dart';
import '../widgets/campus_action_card.dart';
import '../widgets/common_widgets.dart';
import 'service_router.dart';

/// "Services" tab – searchable list of every campus service.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = SampleData.services
        .where(
          (s) =>
              s.title.toLowerCase().contains(_query) ||
              s.subtitle.toLowerCase().contains(_query),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Campus services')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _search,
                onChanged: (v) =>
                    setState(() => _query = v.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Search services (e.g. fees, bus, grades)',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () {
                            _search.clear();
                            setState(() => _query = '');
                          },
                        ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _EntryCard(
                      icon: Icons.campaign_rounded,
                      title: 'Announcements',
                      subtitle: '8 campus updates',
                      onTap: () => openAnnouncements(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _EntryCard(
                      icon: Icons.volunteer_activism_rounded,
                      title: 'Student services',
                      subtitle: 'Support & wellbeing',
                      onTap: () => openSupportServices(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${results.length} service${results.length == 1 ? '' : 's'} available',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 10),
              if (results.isEmpty)
                const EmptyState(
                  icon: Icons.search_off_rounded,
                  message: 'No services match your search.',
                )
              else
                CampusServiceGrid(
                  services: results,
                  onServiceTap: (s) => openService(context, s.id),
                ),
              const SizedBox(height: 20),
              // Emergency contact strip
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.dangerTint,
                  borderRadius: AppStyle.cardRadius,
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const IconTile(
                      icon: Icons.local_hospital_rounded,
                      color: Colors.white,
                      background: AppColors.danger,
                      size: 44,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Campus security · 24/7',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.danger,
                            ),
                          ),
                          Text(
                            'Emergency line: 555-0100',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.danger,
                      ),
                      onPressed: () => showCampusSnackBar(
                        context,
                        'Calling campus security (demo)…',
                        icon: Icons.call_rounded,
                      ),
                      child: const Text('Call'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CampusCard(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          IconTile(
            icon: icon,
            color: AppColors.abyss,
            background: AppColors.flame,
            size: 42,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
