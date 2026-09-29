import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'animations.dart';
import 'common_widgets.dart';

class QuickAction {
  const QuickAction(this.label, this.icon, this.color, this.tint, this.onTap);

  final String label;
  final IconData icon;
  final Color color;
  final Color tint;
  final VoidCallback onTap;
}

/// Bottom sheet opened by the centre "+" button. Tiles pop in one by one.
Future<void> showQuickActionsSheet(
  BuildContext context,
  List<QuickAction> actions,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _QuickActionsSheet(actions: actions),
  );
}

class _QuickActionsSheet extends StatefulWidget {
  const _QuickActionsSheet({required this.actions});

  final List<QuickAction> actions;

  @override
  State<_QuickActionsSheet> createState() => _QuickActionsSheetState();
}

class _QuickActionsSheetState extends State<_QuickActionsSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _controller.value = 1;
    } else if (_controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.actions.length;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          24 + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: const BoxDecoration(
          color: AppColors.ivory,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Quick actions', style: AppStyle.heading),
            const SizedBox(height: 4),
            const Text(
              'Jump straight to the things you do most',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 18),
            LayoutBuilder(
              builder: (context, constraints) {
                const gap = 12.0;
                final w = (constraints.maxWidth - gap * 2) / 3;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (var i = 0; i < count; i++)
                      _AnimatedTile(
                        animation: CurvedAnimation(
                          parent: _controller,
                          curve: Interval(
                            i * 0.07,
                            0.55 + i * 0.07,
                            curve: Curves.easeOutBack,
                          ),
                        ),
                        child: _ActionTile(action: widget.actions[i], width: w),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedTile extends StatelessWidget {
  const _AnimatedTile({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final v = animation.value;
        return Opacity(
          opacity: v.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, (1 - v) * 24),
            child: Transform.scale(scale: 0.8 + 0.2 * v, child: child),
          ),
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action, required this.width});

  final QuickAction action;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: action.label,
      excludeSemantics: true,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: action.tint,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: action.color.withValues(alpha: 0.2)),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.pop(context);
              action.onTap();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  IconTile(
                    icon: action.icon,
                    color: Colors.white,
                    background: action.color,
                    size: 46,
                    circle: true,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    action.label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: action.color,
                    ),
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
