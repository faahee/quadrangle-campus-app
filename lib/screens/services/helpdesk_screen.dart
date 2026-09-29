import 'package:flutter/material.dart';

import '../../data/sample_data.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class HelpdeskScreen extends StatelessWidget {
  const HelpdeskScreen({super.key});

  void _newTicket(BuildContext context, AppState state) {
    final formKey = GlobalKey<FormState>();
    final subject = TextEditingController();
    String category = SampleData.ticketCategories.first;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          24 + MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('New support ticket', style: AppStyle.heading),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Department'),
                items: [
                  for (final c in SampleData.ticketCategories)
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: (v) => category = v ?? category,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: subject,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Describe the issue',
                  hintText: 'e.g. My timetable shows the wrong lab room',
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().length < 5)
                    ? 'Please enter at least 5 characters'
                    : null,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  final ticket = state.addTicket(category, subject.text.trim());
                  Navigator.pop(sheetContext);
                  showCampusSnackBar(
                    context,
                    'Ticket ${ticket.id} submitted to $category',
                    icon: Icons.confirmation_number_rounded,
                  );
                },
                icon: const Icon(Icons.send_rounded),
                label: const Text('Submit ticket'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Helpdesk')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.navy,
        onPressed: () => _newTicket(context, state),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New ticket',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('How can we help?', style: AppStyle.heading),
              const SizedBox(height: 4),
              const Text(
                'Student Services · Mon–Fri, 8:30 AM – 5:30 PM',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _ContactTile(
                    icon: Icons.call_rounded,
                    label: 'Call',
                    onTap: () => showCampusSnackBar(
                      context,
                      'Calling Student Services 555-0142 (demo)…',
                      icon: Icons.call_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ContactTile(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    onTap: () => showCampusSnackBar(
                      context,
                      'Opening email to help@kingsbridge.edu (demo)',
                      icon: Icons.email_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ContactTile(
                    icon: Icons.chat_rounded,
                    label: 'Live chat',
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (d) => AlertDialog(
                        icon: const Icon(
                          Icons.chat_rounded,
                          color: AppColors.navy,
                        ),
                        title: const Text('Live chat'),
                        content: Text(
                          'Hi ${state.preferredName}! An advisor will join shortly. '
                          'Average wait time: 2 minutes.',
                        ),
                        actions: [
                          FilledButton(
                            onPressed: () => Navigator.pop(d),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'My tickets (${state.tickets.length})',
                style: AppStyle.heading.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 10),
              for (final t in state.tickets)
                CampusCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const IconTile(
                        icon: Icons.confirmation_number_outlined,
                        color: Color(0xFF37516B),
                        background: Color(0xFFE5ECF2),
                        size: 42,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.subject,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${t.id} · ${t.category} · ${t.date}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(label: t.status, compact: true),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Frequently asked questions',
                style: AppStyle.heading.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 10),
              CampusCard(
                padding: EdgeInsets.zero,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: Column(
                    children: [
                      for (final faq in SampleData.faqs)
                        ExpansionTile(
                          leading: const Icon(
                            Icons.help_outline_rounded,
                            color: AppColors.navy,
                          ),
                          title: Text(
                            faq.key,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            14,
                          ),
                          children: [
                            Text(
                              faq.value,
                              style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.45,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CampusCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 14),
        onTap: onTap,
        child: Column(
          children: [
            IconTile(
              icon: icon,
              color: Colors.white,
              background: AppColors.navy,
              size: 40,
              circle: true,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
