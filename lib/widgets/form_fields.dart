import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Custom, reusable form widgets for the request form.
///
/// Every input is a [FormField], so it takes part in [Form] validation,
/// saving and resetting exactly like a built-in [TextFormField].

/// Shared input decoration for text fields.
InputDecoration campusInputDecoration({
  required String label,
  String? hint,
  String? helper,
  IconData? icon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    helperText: helper,
    helperMaxLines: 2,
    prefixIcon: icon == null ? null : Icon(icon, color: AppColors.navy),
    filled: true,
    fillColor: Colors.white,
    labelStyle: const TextStyle(color: AppColors.muted),
    floatingLabelStyle: const TextStyle(
      color: AppColors.navy,
      fontWeight: FontWeight.w700,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.flame, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.truffle),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.truffle, width: 2),
    ),
    errorStyle: const TextStyle(color: AppColors.truffle),
  );
}

/// A numbered card that groups related fields.
class FormSection extends StatelessWidget {
  const FormSection({
    super.key,
    required this.step,
    required this.title,
    required this.children,
    this.subtitle,
  });

  final int step;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
      decoration: AppStyle.card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.flame,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$step',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.abyss,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppStyle.heading.copyWith(fontSize: 17)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.muted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Text input with the shared campus styling and spacing.
class CampusTextField extends StatelessWidget {
  const CampusTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.helper,
    this.icon,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? helper;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final int maxLines;
  final int? maxLength;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly,
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textInputAction: maxLines > 1
            ? TextInputAction.newline
            : textInputAction,
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(
          color: readOnly ? AppColors.muted : AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        decoration:
            campusInputDecoration(
              label: label,
              hint: hint,
              helper: helper,
              icon: icon,
            ).copyWith(
              fillColor: readOnly ? AppColors.parchment : Colors.white,
              suffixIcon: readOnly
                  ? const Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                      color: AppColors.muted,
                    )
                  : null,
            ),
      ),
    );
  }
}

/// Small helper that shows a field's validation error under custom inputs.
class _FieldError extends StatelessWidget {
  const _FieldError(this.text);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: text == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 16,
                    color: AppColors.truffle,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      text!,
                      style: const TextStyle(
                        color: AppColors.truffle,
                        fontSize: 12.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// Field label used above the custom (non-text) inputs.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

/// One option shown by [TileSelectFormField].
class TileOption<T> {
  const TileOption(this.value, this.label, this.icon);

  final T value;
  final String label;
  final IconData icon;
}

/// A grid of selectable icon tiles (used for the request type).
class TileSelectFormField<T> extends FormField<T> {
  TileSelectFormField({
    super.key,
    required String label,
    required List<TileOption<T>> options,
    super.initialValue,
    super.validator,
    super.onSaved,
    ValueChanged<T>? onChanged,
  }) : super(
         builder: (field) {
           return Padding(
             padding: const EdgeInsets.only(bottom: 14),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 FieldLabel(label),
                 LayoutBuilder(
                   builder: (context, constraints) {
                     const gap = 10.0;
                     final columns = constraints.maxWidth >= 520 ? 4 : 2;
                     final w =
                         (constraints.maxWidth - gap * (columns - 1)) / columns;
                     return Wrap(
                       spacing: gap,
                       runSpacing: gap,
                       children: [
                         for (final o in options)
                           _SelectTile(
                             width: w,
                             option: o,
                             selected: field.value == o.value,
                             hasError: field.hasError,
                             onTap: () {
                               field.didChange(o.value);
                               onChanged?.call(o.value);
                             },
                           ),
                       ],
                     );
                   },
                 ),
                 _FieldError(field.errorText),
               ],
             ),
           );
         },
       );
}

class _SelectTile<T> extends StatelessWidget {
  const _SelectTile({
    required this.width,
    required this.option,
    required this.selected,
    required this.hasError,
    required this.onTap,
  });

  final double width;
  final TileOption<T> option;
  final bool selected;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: option.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: width,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.navy : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? AppColors.navy
                  : hasError
                  ? AppColors.truffle.withValues(alpha: 0.6)
                  : AppColors.line,
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.navy.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            children: [
              Icon(
                option.icon,
                size: 20,
                color: selected ? AppColors.flame : AppColors.navy,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  option.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: selected ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.flame,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chip-style single choice (used for the contact method).
class ChipChoiceFormField<T> extends FormField<T> {
  ChipChoiceFormField({
    super.key,
    required String label,
    required Map<T, String> options,
    Map<T, IconData> icons = const {},
    super.initialValue,
    super.validator,
    super.onSaved,
    ValueChanged<T>? onChanged,
  }) : super(
         builder: (field) {
           return Padding(
             padding: const EdgeInsets.only(bottom: 14),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 FieldLabel(label),
                 Wrap(
                   spacing: 8,
                   runSpacing: 8,
                   children: [
                     for (final entry in options.entries)
                       ChoiceChip(
                         avatar: icons[entry.key] == null
                             ? null
                             : Icon(
                                 icons[entry.key],
                                 size: 18,
                                 color: field.value == entry.key
                                     ? AppColors.flame
                                     : AppColors.navy,
                               ),
                         label: Text(entry.value),
                         selected: field.value == entry.key,
                         showCheckmark: false,
                         labelStyle: TextStyle(
                           fontWeight: FontWeight.w700,
                           color: field.value == entry.key
                               ? Colors.white
                               : AppColors.ink,
                         ),
                         onSelected: (_) {
                           field.didChange(entry.key);
                           onChanged?.call(entry.key);
                         },
                       ),
                   ],
                 ),
                 _FieldError(field.errorText),
               ],
             ),
           );
         },
       );
}

/// Low / Normal / Urgent selector built on [SegmentedButton].
class PriorityFormField extends FormField<String> {
  PriorityFormField({super.key, super.initialValue = 'Normal', super.onSaved})
    : super(
        builder: (field) {
          const colors = {
            'Low': AppColors.success,
            'Normal': AppColors.navy,
            'Urgent': AppColors.truffle,
          };
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FieldLabel('Priority'),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Low',
                      label: Text('Low'),
                      icon: Icon(Icons.south_rounded),
                    ),
                    ButtonSegment(
                      value: 'Normal',
                      label: Text('Normal'),
                      icon: Icon(Icons.remove_rounded),
                    ),
                    ButtonSegment(
                      value: 'Urgent',
                      label: Text('Urgent'),
                      icon: Icon(Icons.priority_high_rounded),
                    ),
                  ],
                  selected: {field.value ?? 'Normal'},
                  showSelectedIcon: false,
                  onSelectionChanged: (v) => field.didChange(v.first),
                  style: ButtonStyle(
                    minimumSize: const WidgetStatePropertyAll(Size(0, 48)),
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? colors[field.value]
                          : Colors.white,
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? Colors.white
                          : AppColors.ink,
                    ),
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: AppColors.line),
                    ),
                    textStyle: const WidgetStatePropertyAll(
                      TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
}

/// Date input that opens a themed date picker.
class DateFormField extends FormField<DateTime> {
  DateFormField({
    super.key,
    required String label,
    required DateTime firstDate,
    required DateTime lastDate,
    String? helper,
    super.initialValue,
    super.validator,
    super.onSaved,
  }) : super(
         builder: (field) {
           const months = [
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
           const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
           final v = field.value;
           Future<void> pick() async {
             final picked = await showDatePicker(
               context: field.context,
               initialDate: v ?? firstDate,
               firstDate: firstDate,
               lastDate: lastDate,
               helpText: label.toUpperCase(),
             );
             if (picked != null) field.didChange(picked);
           }

           return Padding(
             padding: const EdgeInsets.only(bottom: 14),
             child: Semantics(
               button: true,
               label: label,
               child: InkWell(
                 onTap: pick,
                 borderRadius: BorderRadius.circular(14),
                 child: InputDecorator(
                   isEmpty: v == null,
                   decoration:
                       campusInputDecoration(
                         label: label,
                         helper: helper,
                         icon: Icons.event_rounded,
                       ).copyWith(
                         errorText: field.errorText,
                         suffixIcon: const Icon(Icons.expand_more_rounded),
                       ),
                   child: Text(
                     v == null
                         ? ''
                         : '${days[v.weekday - 1]}, ${v.day} ${months[v.month - 1]} ${v.year}',
                     style: const TextStyle(
                       fontWeight: FontWeight.w600,
                       color: AppColors.ink,
                     ),
                   ),
                 ),
               ),
             ),
           );
         },
       );
}

/// Required "I confirm…" checkbox.
class ConsentFormField extends FormField<bool> {
  ConsentFormField({
    super.key,
    required String text,
    super.initialValue = false,
    super.onSaved,
  }) : super(
         validator: (v) =>
             v == true ? null : 'Please confirm before submitting',
         builder: (field) {
           final checked = field.value ?? false;
           return Padding(
             padding: const EdgeInsets.only(bottom: 14),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 InkWell(
                   onTap: () => field.didChange(!checked),
                   borderRadius: BorderRadius.circular(14),
                   child: AnimatedContainer(
                     duration: const Duration(milliseconds: 200),
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: checked ? AppColors.successTint : Colors.white,
                       borderRadius: BorderRadius.circular(14),
                       border: Border.all(
                         color: field.hasError
                             ? AppColors.truffle
                             : checked
                             ? AppColors.success
                             : AppColors.line,
                       ),
                     ),
                     child: Row(
                       children: [
                         Checkbox(
                           value: checked,
                           activeColor: AppColors.success,
                           onChanged: (v) => field.didChange(v ?? false),
                         ),
                         const SizedBox(width: 4),
                         Expanded(
                           child: Text(
                             text,
                             style: const TextStyle(fontSize: 13.5),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
                 _FieldError(field.errorText),
               ],
             ),
           );
         },
       );
}
