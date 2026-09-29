import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import '../widgets/event_card.dart';
import 'service_router.dart';

/// Full list of upcoming student-life events.
class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final registered = SampleData.events
        .where((e) => state.isRegistered(e.id))
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Student life')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'You are registered for $registered of ${SampleData.events.length} upcoming events.',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 14),
              for (final event in SampleData.events)
                EventCard(
                  event: event,
                  registered: state.isRegistered(event.id),
                  margin: const EdgeInsets.only(bottom: 12),
                  onTap: () => openEvent(context, event),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
