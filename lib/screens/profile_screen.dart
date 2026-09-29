import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/sample_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'events_screen.dart';
import 'home_shell.dart';
import 'service_router.dart';

/// "Profile" tab – student details, activity, settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    const student = SampleData.student;
    final openTickets = state.tickets
        .where((t) => t.status != 'Resolved')
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: SingleChildScrollView(
        child: ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.navy, AppColors.navyLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: AppStyle.cardRadius,
                  boxShadow: AppStyle.softShadow,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF2B3E66),
                        border: Border.all(color: AppColors.gold, width: 3),
                      ),
                      child: Text(
                        student.initials,
                        style: const TextStyle(
                          fontFamily: 'Georgia',
                          fontFamilyFallback: AppStyle.serifFallback,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      student.fullName,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontFamilyFallback: AppStyle.serifFallback,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Preferred name: ${state.preferredName}',
                      style: const TextStyle(
                        color: Color(0xFFCBD3E4),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${student.studentId} · ${student.programme}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: AppColors.navy,
                            ),
                            onPressed: () => showDigitalIdDialog(context),
                            icon: const Icon(Icons.badge_rounded),
                            label: const Text('Digital ID'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                            ),
                            onPressed: () => _editName(context, state),
                            icon: const Icon(Icons.edit_rounded),
                            label: const Text('Edit name'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Activity counters
              Row(
                children: [
                  _CounterTile(
                    value: '${state.registeredEvents.length}',
                    label: 'Events',
                    icon: Icons.event_available_rounded,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const EventsScreen()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _CounterTile(
                    value: '${state.joinedClubs.length}',
                    label: 'Clubs',
                    icon: Icons.groups_rounded,
                    onTap: () => openService(context, 'clubs'),
                  ),
                  const SizedBox(width: 10),
                  _CounterTile(
                    value: '$openTickets',
                    label: 'Tickets',
                    icon: Icons.support_agent_rounded,
                    onTap: () => openService(context, 'helpdesk'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Personal details
              CampusCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    _DetailTile(
                      icon: Icons.email_outlined,
                      label: 'Student email',
                      value: student.email,
                      trailing: Icons.copy_rounded,
                      onTap: () => _copy(context, student.email, 'Email'),
                    ),
                    _DetailTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: student.phone,
                      trailing: Icons.copy_rounded,
                      onTap: () =>
                          _copy(context, student.phone, 'Phone number'),
                    ),
                    _DetailTile(
                      icon: Icons.apartment_rounded,
                      label: 'Faculty',
                      value: student.faculty,
                    ),
                    _DetailTile(
                      icon: Icons.person_pin_rounded,
                      label: 'Academic advisor',
                      value: student.advisor,
                    ),
                    _DetailTile(
                      icon: Icons.event_note_rounded,
                      label: 'Intake',
                      value:
                          '${student.intake} · ${student.yearLabel}, ${student.semester}',
                    ),
                    _DetailTile(
                      icon: Icons.home_work_outlined,
                      label: 'Residence',
                      value: student.hostel,
                    ),
                  ],
                ),
              ),
              // Settings
              CampusCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.notifications_active_outlined,
                        color: AppColors.navy,
                      ),
                      title: const Text('Push notifications'),
                      subtitle: const Text('Deadlines, events and alerts'),
                      value: state.pushNotifications,
                      onChanged: (v) {
                        state.setPushNotifications(v);
                        showCampusSnackBar(
                          context,
                          'Push notifications ${v ? 'enabled' : 'disabled'}',
                        );
                      },
                    ),
                    SwitchListTile(
                      secondary: const Icon(
                        Icons.mark_email_unread_outlined,
                        color: AppColors.navy,
                      ),
                      title: const Text('Weekly email digest'),
                      subtitle: const Text('Summary every Monday morning'),
                      value: state.emailDigest,
                      onChanged: (v) {
                        state.setEmailDigest(v);
                        showCampusSnackBar(
                          context,
                          'Weekly digest ${v ? 'enabled' : 'disabled'}',
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.notifications_none_rounded,
                        color: AppColors.navy,
                      ),
                      title: const Text('View my alerts'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => onOpenTab(Tabs.alerts),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.navy,
                      ),
                      title: const Text('About ${SampleData.appName}'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showAboutDialog(
                        context: context,
                        applicationName: SampleData.appName,
                        applicationVersion: 'v1.0 (prototype)',
                        applicationIcon: const IconTile(
                          icon: Icons.account_balance_rounded,
                          color: AppColors.gold,
                          background: AppColors.navy,
                          size: 48,
                        ),
                        children: const [
                          Text(
                            'Student Campus App for ${SampleData.university}. '
                            'Built with Flutter Container widgets. '
                            'All data shown is fictional sample data.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                ),
                onPressed: () => _confirmSignOut(context),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copy(BuildContext context, String text, String what) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      showCampusSnackBar(
        context,
        '$what copied to clipboard',
        icon: Icons.copy_rounded,
      );
    }
  }

  void _editName(BuildContext context, AppState state) {
    final controller = TextEditingController(text: state.preferredName);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Preferred name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Name used in your greeting',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              state.updatePreferredName(controller.text);
              Navigator.pop(dialogContext);
              showCampusSnackBar(
                context,
                'Greeting updated to "${state.preferredName}"',
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
        title: const Text('Sign out?'),
        content: const Text(
          'This is a prototype, so signing out simply returns you to the dashboard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Stay'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () {
              Navigator.pop(dialogContext);
              onOpenTab(Tabs.home);
              showCampusSnackBar(
                context,
                'Signed out (demo mode)',
                icon: Icons.logout_rounded,
              );
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}

/// Shows the digital student ID card (also used by Quick actions).
void showDigitalIdDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _DigitalIdCard(),
          const SizedBox(height: 14),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.navy,
            ),
            onPressed: () => Navigator.pop(dialogContext),
            icon: const Icon(Icons.close_rounded),
            label: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}

class _CounterTile extends StatelessWidget {
  const _CounterTile({
    required this.value,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
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
            Icon(icon, color: AppColors.gold),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontFamilyFallback: AppStyle.serifFallback,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final IconData? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: IconTile(
        icon: icon,
        color: AppColors.navy,
        background: AppColors.parchment,
        size: 38,
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 12.5, color: AppColors.muted),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
      trailing: trailing == null
          ? null
          : Icon(trailing, size: 18, color: AppColors.muted),
    );
  }
}

/// Student ID card – a showcase of Container decoration:
/// gradient, border, radius, shadow, Stack watermark and a fake barcode.
class _DigitalIdCard extends StatelessWidget {
  const _DigitalIdCard();

  @override
  Widget build(BuildContext context) {
    const student = SampleData.student;
    final random = Random(student.studentId.hashCode);

    return Container(
      constraints: const BoxConstraints(maxWidth: 380),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2B4F), AppColors.navy],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -10,
            child: Icon(
              Icons.account_balance_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.account_balance_rounded,
                    color: AppColors.gold,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'KINGSBRIDGE UNIVERSITY',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 84,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B3E66),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Text(
                      student.initials,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontFamilyFallback: AppStyle.serifFallback,
                        fontSize: 26,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          student.programme,
                          style: const TextStyle(
                            color: Color(0xFFCBD3E4),
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID  ${student.studentId}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const Text(
                          'Valid until Aug 2027',
                          style: TextStyle(
                            color: Color(0xFFCBD3E4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Barcode made from thin Containers of random width
              Container(
                height: 46,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    for (var i = 0; i < 44; i++)
                      Expanded(
                        flex: 1 + random.nextInt(3),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 0.6),
                          decoration: BoxDecoration(
                            color: i.isEven ? AppColors.navy : Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
