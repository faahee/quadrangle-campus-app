import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NavDestinationData {
  const NavDestinationData(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// Detached, frosted-glass bottom navigation with a raised centre button.
///
/// Container techniques: explicit height, BoxConstraints(maxWidth),
/// BoxDecoration with radius / border / shadow, and a circular gradient
/// action button.
class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    required this.onCenterTap,
    this.centerOpen = false,
    this.visible = true,
    this.badges = const {},
  });

  /// Exactly four destinations – two either side of the centre button.
  final List<NavDestinationData> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onCenterTap;
  final bool centerOpen;
  final bool visible;
  final Map<int, int> badges;

  static const double _pillHeight = 68;
  static const double _raise = 18;

  @override
  Widget build(BuildContext context) {
    Widget item(int i) => Expanded(
      child: _NavItem(
        data: destinations[i],
        selected: i == selectedIndex,
        badge: badges[i] ?? 0,
        onTap: () => onSelected(i),
      ),
    );

    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 1.4),
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 260),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: Align(
            heightFactor: 1,
            child: Container(
              height: _pillHeight + _raise,
              constraints: const BoxConstraints(maxWidth: 480),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Soft shadow under the pill
                  Positioned.fill(
                    top: _raise,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.navy.withValues(alpha: 0.18),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Frosted glass pill
                  Positioned.fill(
                    top: _raise,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(34),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.86),
                            borderRadius: BorderRadius.circular(34),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          child: Row(
                            children: [
                              item(0),
                              item(1),
                              const SizedBox(width: 72),
                              item(2),
                              item(3),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Raised centre action button
                  Positioned(
                    top: 0,
                    child: _CenterButton(open: centerOpen, onTap: onCenterTap),
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

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.selected,
    required this.badge,
    required this.onTap,
  });

  final NavDestinationData data;
  final bool selected;
  final int badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.navy : AppColors.muted;
    return Semantics(
      button: true,
      selected: selected,
      label: badge > 0 ? '${data.label}, $badge unread' : data.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        highlightShape: BoxShape.rectangle,
        containedInkWell: true,
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: FloatingNavBar._pillHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                padding: EdgeInsets.symmetric(
                  horizontal: selected ? 16 : 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: selected ? AppColors.parchment : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Badge(
                  isLabelVisible: badge > 0,
                  label: Text('$badge'),
                  child: AnimatedScale(
                    scale: selected ? 1.08 : 1,
                    duration: const Duration(milliseconds: 280),
                    child: Icon(
                      selected ? data.selectedIcon : data.icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 280),
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  color: color,
                ),
                child: Text(data.label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterButton extends StatelessWidget {
  const _CenterButton({required this.open, required this.onTap});

  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Quick actions',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          width: 62,
          height: 62,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: open
                  ? const [AppColors.goldDeep, AppColors.gold]
                  : const [AppColors.navyLight, AppColors.navy],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedRotation(
            turns: open ? 0.125 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            child: Icon(
              Icons.add_rounded,
              size: 32,
              color: open ? AppColors.navy : AppColors.gold,
            ),
          ),
        ),
      ),
    );
  }
}
