import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final categories = [
      'All',
      'Joined',
      ...{for (final c in SampleData.clubs) c.category},
    ];
    final clubs = SampleData.clubs.where(
      (c) => switch (_category) {
        'All' => true,
        'Joined' => state.isMember(c.id),
        _ => c.category == _category,
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Clubs & societies')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You are a member of ${state.joinedClubs.length} club${state.joinedClubs.length == 1 ? '' : 's'}.',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final c in categories)
                    ChoiceChip(
                      label: Text(c),
                      selected: c == _category,
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: c == _category ? Colors.white : AppColors.ink,
                        fontWeight: FontWeight.w600,
                      ),
                      onSelected: (_) => setState(() => _category = c),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              if (clubs.isEmpty)
                const EmptyState(
                  icon: Icons.groups_outlined,
                  message: 'No clubs here yet – try another filter.',
                ),
              for (final club in clubs)
                Builder(
                  builder: (context) {
                    final joined = state.isMember(club.id);
                    return CampusCard(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconTile(
                                icon: club.icon,
                                color: Colors.white,
                                background: club.color,
                                size: 48,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      club.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '${club.category} · ${club.members + (joined ? 1 : 0)} members',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (joined)
                                const StatusBadge(
                                  label: 'Joined',
                                  compact: true,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            club.description,
                            style: const TextStyle(fontSize: 13.5, height: 1.4),
                          ),
                          InfoRow(
                            icon: Icons.schedule_rounded,
                            text: club.meets,
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: joined
                                ? OutlinedButton(
                                    onPressed: () {
                                      state.toggleClub(club.id);
                                      showCampusSnackBar(
                                        context,
                                        'You left ${club.name}',
                                        icon: Icons.logout_rounded,
                                      );
                                    },
                                    child: const Text('Leave club'),
                                  )
                                : FilledButton(
                                    style: FilledButton.styleFrom(
                                      backgroundColor: club.color,
                                    ),
                                    onPressed: () {
                                      state.toggleClub(club.id);
                                      showCampusSnackBar(
                                        context,
                                        'Welcome to ${club.name}!',
                                        icon: Icons.celebration_rounded,
                                      );
                                    },
                                    child: const Text('Join club'),
                                  ),
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
