import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/sample_data.dart';
import '../../navigation/app_routes.dart';
import '../../state/app_state.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
String _fmt(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

/// "Requests & support": the student's submitted requests (with status),
/// a button to open the request form, contact options and FAQs.
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  String _filter = 'All';

  Future<void> _newRequest() async {
    final result = await Navigator.of(context).pushNamed(AppRoutes.newRequest);
    if (result is StudentRequest && mounted) {
      setState(() => _filter = 'All');
      showCampusSnackBar(
        context,
        '${result.id} added to My requests',
        icon: Icons.task_alt_rounded,
      );
    }
  }

  void _showDetails(StudentRequest r) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StatusBadge(label: r.status.label),
                  const SizedBox(width: 8),
                  StatusBadge(label: '${r.priority} priority'),
                ],
              ),
              const SizedBox(height: 12),
              Text(r.subject, style: AppStyle.heading),
              const SizedBox(height: 4),
              Text(
                '${r.id} · ${r.type.label}',
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              _StatusStepper(status: r.status),
              const SizedBox(height: 16),
              Text(r.details, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 14),
              InfoRow(
                icon: Icons.send_rounded,
                text: 'Submitted ${_fmt(r.submittedOn)}',
                fontSize: 14,
              ),
              InfoRow(
                icon: Icons.event_rounded,
                text: 'Needed by ${_fmt(r.preferredDate)}',
                fontSize: 14,
              ),
              InfoRow(
                icon: Icons.forum_outlined,
                text: r.phone == null
                    ? 'Contact by ${r.contactMethod.toLowerCase()}'
                    : 'Contact by phone · ${r.phone}',
                fontSize: 14,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Close'),
                ),
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
    final requests = state.requests.where(
      (r) => switch (_filter) {
        'Open' => r.isOpen,
        'Completed' => !r.isOpen,
        _ => true,
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Requests & support')),
      // Lifted above the floating nav bar that overlaps tab pages.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: FloatingActionButton.extended(
          heroTag: 'new-request',
          backgroundColor: AppColors.flame,
          foregroundColor: AppColors.abyss,
          onPressed: _newRequest,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'New request',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary banner
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.abyss, AppColors.blueFantastic],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppStyle.cardRadius,
                  boxShadow: AppStyle.softShadow,
                ),
                child: Row(
                  children: [
                    _Stat(value: '${state.openRequests}', label: 'Open'),
                    _Stat(
                      value: '${state.requests.length - state.openRequests}',
                      label: 'Completed',
                    ),
                    _Stat(value: '2 days', label: 'Avg. reply'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              CampusCard(
                onTap: _newRequest,
                child: const Row(
                  children: [
                    IconTile(
                      icon: Icons.edit_note_rounded,
                      color: AppColors.abyss,
                      background: AppColors.flame,
                      size: 46,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Submit a new request',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Transcripts, letters, leave, course changes, repairs and more',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: AppColors.navy),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'My requests',
                      style: AppStyle.heading.copyWith(fontSize: 17),
                    ),
                  ),
                  for (final f in const ['All', 'Open', 'Completed'])
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ChoiceChip(
                        label: Text(f),
                        selected: _filter == f,
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _filter == f ? Colors.white : AppColors.ink,
                        ),
                        onSelected: (_) => setState(() => _filter = f),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (requests.isEmpty)
                const EmptyState(
                  icon: Icons.inbox_rounded,
                  message: 'No requests here yet.',
                ),
              for (final r in requests)
                CampusCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () => _showDetails(r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconTile(
                            icon: r.type.icon,
                            color: AppColors.navy,
                            background: AppColors.parchment,
                            size: 42,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.subject,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '${r.id} · ${r.type.label} · ${_fmt(r.submittedOn)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          StatusBadge(label: r.status.label, compact: true),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _StatusStepper(status: r.status, compact: true),
                    ],
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Contact student services',
                style: AppStyle.heading.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 4),
              const Text(
                'Mon–Fri, 8:30 AM – 5:30 PM',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _ContactTile(
                    icon: Icons.call_rounded,
                    label: 'Call',
                    onTap: () => showCampusSnackBar(
                      context,
                      'Calling Student Services (demo)…',
                      icon: Icons.call_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ContactTile(
                    icon: Icons.email_rounded,
                    label: 'Email',
                    onTap: () => showCampusSnackBar(
                      context,
                      'Opening email to help@campus.example (demo)',
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

/// Four-step progress line: Submitted → In review → Approved → Completed.
class _StatusStepper extends StatelessWidget {
  const _StatusStepper({required this.status, this.compact = false});

  final RequestStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final current = status.index;
    return Row(
      children: [
        for (final s in RequestStatus.values) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: s.index <= current
                        ? (status == RequestStatus.completed
                              ? AppColors.success
                              : AppColors.flame)
                        : AppColors.line,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 6),
                  Text(
                    s.label,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: s.index == current
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: s.index <= current
                          ? AppColors.ink
                          : AppColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontFamilyFallback: AppStyle.serifFallback,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.flame,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: AppColors.oatmeal),
          ),
        ],
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
