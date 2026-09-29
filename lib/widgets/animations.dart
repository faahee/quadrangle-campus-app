import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../theme/app_theme.dart';

/// True when the user (or a test) asked the platform to reduce motion.
bool reduceMotion(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;

enum RevealFrom { bottom, left, right }

/// Fades + slides its child into place the first time it scrolls into view.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.from = RevealFrom.bottom,
    this.distance = 36,
    this.duration = const Duration(milliseconds: 700),
  });

  final Widget child;
  final Duration delay;
  final RevealFrom from;
  final double distance;
  final Duration duration;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  ScrollPosition? _position;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _started = true;
      _controller.value = 1;
      return;
    }
    final position = Scrollable.maybeOf(context, axis: Axis.vertical)?.position;
    if (position != _position) {
      _position?.removeListener(_check);
      _position = position?..addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_started || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < MediaQuery.sizeOf(context).height - 24) {
      _started = true;
      _position?.removeListener(_check);
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final v = _curve.value;
        final d = (1 - v) * widget.distance;
        final offset = switch (widget.from) {
          RevealFrom.bottom => Offset(0, d),
          RevealFrom.left => Offset(-d, 0),
          RevealFrom.right => Offset(d, 0),
        };
        return Opacity(
          opacity: v,
          child: Transform.translate(
            offset: offset,
            child: Transform.scale(scale: 0.96 + 0.04 * v, child: child),
          ),
        );
      },
    );
  }
}

/// Gently bobs its child up and down forever – the "floating" effect.
class Floating extends StatefulWidget {
  const Floating({
    super.key,
    required this.child,
    this.amplitude = 6,
    this.period = const Duration(seconds: 4),
    this.phase = 0,
  });

  final Widget child;
  final double amplitude;
  final Duration period;
  final double phase;

  @override
  State<Floating> createState() => _FloatingState();
}

class _FloatingState extends State<Floating>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final t = (_controller.value + widget.phase) * 2 * math.pi;
        return Transform.translate(
          offset: Offset(0, math.sin(t) * widget.amplitude),
          child: child,
        );
      },
    );
  }
}

/// Lifts a card and deepens its shadow while the mouse hovers (desktop/web).
class HoverLift extends StatefulWidget {
  const HoverLift({
    super.key,
    required this.child,
    this.radius = AppStyle.radius,
    this.lift = 5,
  });

  final Widget child;
  final double radius;
  final double lift;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -widget.lift : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: _hovered ? 0.16 : 0),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}

/// Counts a number up from zero, e.g. 0.00 → 3.68.
class CountUp extends StatelessWidget {
  const CountUp({
    super.key,
    required this.value,
    required this.style,
    this.decimals = 0,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1400),
  });

  final double value;
  final TextStyle style;
  final int decimals;
  final String suffix;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: reduceMotion(context) ? Duration.zero : duration,
      curve: Curves.easeOutCubic,
      builder: (context, v, _) =>
          Text('${v.toStringAsFixed(decimals)}$suffix', style: style),
    );
  }
}

/// Progress bar that fills up when it first appears.
class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.value,
    this.color = AppColors.gold,
    this.background = AppColors.parchment,
    this.height = 5,
  });

  final double value;
  final Color color;
  final Color background;
  final double height;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: reduceMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, v, _) => ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: LinearProgressIndicator(
          value: v,
          minHeight: height,
          backgroundColor: background,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}

/// Endless horizontal ticker (like a logo marquee).
class Marquee extends StatefulWidget {
  const Marquee({
    super.key,
    required this.items,
    this.speed = 38,
    this.height = 40,
  });

  final List<Widget> items;
  final double speed; // logical pixels per second
  final double height;

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  final _controller = ScrollController();
  late final Ticker _ticker = createTicker(_tick);
  Duration _last = Duration.zero;

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (_controller.hasClients) {
      _controller.jumpTo(_controller.offset + widget.speed * dt);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (reduceMotion(context)) {
      if (_ticker.isActive) _ticker.stop();
    } else if (!_ticker.isActive) {
      _last = Duration.zero;
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) => widget.items[i % widget.items.length],
      ),
    );
  }
}
