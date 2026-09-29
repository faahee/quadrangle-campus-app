import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Shows a consistent floating SnackBar used for tap feedback everywhere.
void showCampusSnackBar(
  BuildContext context,
  String message, {
  IconData icon = Icons.check_circle_rounded,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.gold, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
}

/// Square icon tile with rounded corners.
/// Container techniques: explicit width/height, alignment, BoxDecoration.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    required this.color,
    required this.background,
    this.size = 44,
    this.circle = false,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}

/// Small pill label such as "New", "Due soon", "Registered".
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.compact = false});

  final String label;
  final bool compact;

  static (Color fg, Color bg) colorsFor(String label) {
    final l = label.toLowerCase();
    if (l.contains('action') ||
        l.contains('delayed') ||
        l.contains('unpaid') ||
        l.contains('overdue') ||
        l.contains('below')) {
      return (AppColors.danger, AppColors.dangerTint);
    }
    if (l.contains('due') ||
        l.contains('notice') ||
        l.contains('diverted') ||
        l.contains('progress') ||
        l.contains('few') ||
        l.contains('pinned')) {
      return (AppColors.warning, AppColors.warningTint);
    }
    if (l.contains('registered') ||
        l.contains('open') ||
        l.contains('live') ||
        l.contains('on time') ||
        l.contains('resolved') ||
        l.contains('paid') ||
        l.contains('joined') ||
        l.contains('good') ||
        l.contains('seats')) {
      return (AppColors.success, AppColors.successTint);
    }
    if (l.contains('new') ||
        l.contains('info') ||
        l.contains('today') ||
        l.contains('submitted')) {
      return (AppColors.info, AppColors.infoTint);
    }
    return (AppColors.goldDeep, AppColors.parchment);
  }

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = colorsFor(label);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: fg,
          fontSize: compact ? 11 : 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

/// Section title with an optional action link on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 28, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(title, style: AppStyle.heading),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionLabel!),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Calendar-style date tile: day number over month abbreviation.
class DateTile extends StatelessWidget {
  const DateTile({
    super.key,
    required this.day,
    required this.month,
    this.color = AppColors.navy,
    this.size = 58,
  });

  final String day;
  final String month;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size + 4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontFamily: 'Georgia',
              fontFamilyFallback: AppStyle.serifFallback,
              fontSize: size * 0.38,
              height: 1.0,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            month,
            style: TextStyle(
              fontSize: size * 0.19,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// A white rounded card with the shared border + soft shadow.
class CampusCard extends StatelessWidget {
  const CampusCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.color = AppColors.surface,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(padding: padding, child: child);
    return Container(
      margin: margin,
      decoration: AppStyle.card(color: color),
      // Transparent Material lets ripples (InkWell / ListTile) paint on top
      // of the card's background colour.
      child: Material(
        type: MaterialType.transparency,
        borderRadius: AppStyle.cardRadius,
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? content
            : InkWell(
                onTap: onTap,
                borderRadius: AppStyle.cardRadius,
                child: content,
              ),
      ),
    );
  }
}

/// Icon + text row used for time / venue / details.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.color = AppColors.muted,
    this.fontSize = 13,
  });

  final IconData icon;
  final String text;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: fontSize + 3, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: fontSize, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

/// Friendly placeholder when a filtered list is empty.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          IconTile(
            icon: icon,
            color: AppColors.muted,
            background: AppColors.parchment,
            size: 64,
            circle: true,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

/// Keeps page content readable on wide screens (tablet / web).
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 760),
        padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: child,
      ),
    );
  }
}
