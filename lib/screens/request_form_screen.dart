import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/sample_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import '../widgets/form_fields.dart';

/// "New request" page – a customised [Form] built from the reusable
/// fields in `form_fields.dart`.
///
/// Features: four grouped sections, custom FormFields (tiles, chips,
/// segmented priority, date picker, consent checkbox), live validation after
/// the first submit, a conditional phone field, Reset, a "discard changes?"
/// guard, and a confirmation dialog with the request reference.
class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController(text: SampleData.student.email);
  final _subject = TextEditingController();
  final _details = TextEditingController();
  final _phone = TextEditingController();

  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  String _contact = 'Email';
  bool _dirty = false;
  bool _submitting = false;

  // Values collected by FormField.onSaved
  RequestType? _type;
  DateTime? _date;
  String _priority = 'Normal';

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _email.dispose();
    _subject.dispose();
    _details.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  void _reset() {
    _formKey.currentState!.reset();
    _email.text = SampleData.student.email;
    _subject.clear();
    _details.clear();
    _phone.clear();
    setState(() {
      _contact = 'Email';
      _dirty = false;
      _autovalidate = AutovalidateMode.disabled;
    });
    showCampusSnackBar(
      context,
      'Form cleared',
      icon: Icons.restart_alt_rounded,
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final form = _formKey.currentState!;
    if (!form.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      showCampusSnackBar(
        context,
        'Please fix the highlighted fields',
        icon: Icons.error_outline_rounded,
      );
      return;
    }
    form.save();

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 700)); // simulated send
    if (!mounted) return;

    final request = AppStateScope.of(context).addRequest(
      type: _type!,
      subject: _subject.text.trim(),
      details: _details.text.trim(),
      preferredDate: _date!,
      priority: _priority,
      contactMethod: _contact,
      phone: _contact == 'Phone' ? _phone.text.trim() : null,
    );
    setState(() {
      _submitting = false;
      _dirty = false;
    });

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.task_alt_rounded,
          color: AppColors.success,
          size: 40,
        ),
        title: const Text('Request submitted'),
        content: Text(
          'Your ${request.type.label.toLowerCase()} request has been sent.\n\n'
          'Reference: ${request.id}\n'
          'We will contact you by ${request.contactMethod.toLowerCase()} '
          'within 2 working days.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Done'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.of(context).pop(request);
  }

  Future<bool> _confirmDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard this request?'),
        content: const Text('The details you entered will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.truffle),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    const student = SampleData.student;
    final today = DateUtils.dateOnly(DateTime.now());

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) {
          setState(() => _dirty = false);
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New request'),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: _reset,
              icon: const Icon(Icons.restart_alt_rounded),
              label: const Text('Reset'),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: _autovalidate,
          onChanged: _markDirty,
          child: SingleChildScrollView(
            child: ResponsiveBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _IntroBanner(student: student),
                  const SizedBox(height: 16),

                  // ---------- 1. Student details ----------
                  FormSection(
                    step: 1,
                    title: 'Your details',
                    subtitle: 'Taken from your student record',
                    children: [
                      CampusTextField(
                        label: 'Full name',
                        initialValue: student.fullName,
                        icon: Icons.person_outline_rounded,
                        readOnly: true,
                      ),
                      CampusTextField(
                        label: 'Student ID',
                        initialValue: student.studentId,
                        icon: Icons.badge_outlined,
                        readOnly: true,
                      ),
                      CampusTextField(
                        label: 'Contact email',
                        controller: _email,
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter an email address';
                          }
                          return _emailPattern.hasMatch(v.trim())
                              ? null
                              : 'Enter a valid email, e.g. name@domain.edu';
                        },
                      ),
                    ],
                  ),

                  // ---------- 2. Request ----------
                  FormSection(
                    step: 2,
                    title: 'Your request',
                    subtitle: 'Tell us what you need',
                    children: [
                      TileSelectFormField<RequestType>(
                        label: 'Request type',
                        options: [
                          for (final t in SampleData.requestTypes)
                            TileOption(t, t.label, t.icon),
                        ],
                        validator: (v) =>
                            v == null ? 'Choose a request type' : null,
                        onSaved: (v) => _type = v,
                      ),
                      CampusTextField(
                        label: 'Subject',
                        controller: _subject,
                        hint: 'e.g. Official transcript for internship',
                        icon: Icons.short_text_rounded,
                        maxLength: 80,
                        validator: (v) => (v == null || v.trim().length < 5)
                            ? 'Subject must be at least 5 characters'
                            : null,
                      ),
                      CampusTextField(
                        label: 'Details',
                        controller: _details,
                        hint: 'Add any information that will help us',
                        helper: 'At least 20 characters',
                        maxLines: 5,
                        maxLength: 500,
                        validator: (v) => (v == null || v.trim().length < 20)
                            ? 'Please describe your request (20+ characters)'
                            : null,
                      ),
                    ],
                  ),

                  // ---------- 3. Scheduling & contact ----------
                  FormSection(
                    step: 3,
                    title: 'Timing & contact',
                    subtitle: 'When you need it and how to reach you',
                    children: [
                      DateFormField(
                        label: 'Needed by',
                        helper: 'Choose a date within the next 90 days',
                        firstDate: today,
                        lastDate: today.add(const Duration(days: 90)),
                        validator: (v) => v == null ? 'Pick a date' : null,
                        onSaved: (v) => _date = v,
                      ),
                      PriorityFormField(onSaved: (v) => _priority = v!),
                      ChipChoiceFormField<String>(
                        label: 'Preferred contact',
                        initialValue: 'Email',
                        options: const {
                          'Email': 'Email',
                          'Phone': 'Phone',
                          'In person': 'In person',
                        },
                        icons: const {
                          'Email': Icons.mail_outline_rounded,
                          'Phone': Icons.call_outlined,
                          'In person': Icons.storefront_outlined,
                        },
                        onChanged: (v) => setState(() => _contact = v),
                      ),
                      // Only asked for when "Phone" is chosen.
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        child: _contact == 'Phone'
                            ? CampusTextField(
                                label: 'Phone number',
                                controller: _phone,
                                hint: '+1 555 014 2291',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (v) {
                                  final digits = (v ?? '').replaceAll(
                                    RegExp(r'\D'),
                                    '',
                                  );
                                  return digits.length < 8
                                      ? 'Enter a valid phone number'
                                      : null;
                                },
                              )
                            : const SizedBox(width: double.infinity),
                      ),
                    ],
                  ),

                  // ---------- 4. Confirm ----------
                  FormSection(
                    step: 4,
                    title: 'Confirm',
                    children: [
                      ConsentFormField(
                        text:
                            'I confirm the information above is correct and '
                            'may be shared with the relevant office.',
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 54,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.flame,
                        foregroundColor: AppColors.abyss,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: _submitting ? null : _submit,
                      icon: _submitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.abyss,
                              ),
                            )
                          : const Icon(Icons.send_rounded),
                      label: Text(
                        _submitting ? 'Submitting…' : 'Submit request',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Requests are answered within 2 working days.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.5, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroBanner extends StatelessWidget {
  const _IntroBanner({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const IconTile(
            icon: Icons.assignment_rounded,
            color: AppColors.abyss,
            background: AppColors.flame,
            size: 48,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi ${student.preferredName}, what do you need?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Fill in the four steps below. Fields marked in red need attention.',
                  style: TextStyle(color: AppColors.oatmeal, fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
