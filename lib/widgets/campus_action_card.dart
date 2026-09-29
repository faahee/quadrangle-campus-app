import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/app_theme.dart';
import 'animations.dart';
import 'common_widgets.dart';

/// Reusable quick-access card used for every campus service.
///
/// Container techniques used here:
///  * width + constraints (minHeight keeps a comfortable 48px+ touch target)
///  * BoxDecoration with tint colour, border radius and a visible border
///  * padding for internal breathing space
///  * Column/Row composition inside the Container
class CampusActionCard extends StatelessWidget {
  const CampusActionCard({
    super.key,
    required this.service,
    required this.onTap,
    this.width,
  });

  final CampusService service;
  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open ${service.title}. ${service.subtitle}',
      child: HoverLift(
        child: Container(
          width: width,
          constraints: const BoxConstraints(minHeight: 128),
          decoration: BoxDecoration(
            color: service.tint,
            borderRadius: AppStyle.cardRadius,
            border: Border.all(color: service.color.withValues(alpha: 0.22)),
          ),
          // Transparent Material so the InkWell ripple shows above the tint.
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              borderRadius: AppStyle.cardRadius,
              splashColor: service.color.withValues(alpha: 0.12),
              highlightColor: service.color.withValues(alpha: 0.06),
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconTile(
                          icon: service.icon,
                          color: Colors.white,
                          background: service.color,
                          size: 46,
                        ),
                        const SizedBox(width: 8),
                        if (service.badge != null)
                          Flexible(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: StatusBadge(
                                label: service.badge!,
                                compact: true,
                              ),
                            ),
                          )
                        else
                          const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            service.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: service.color,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: service.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lays out [CampusActionCard]s in a responsive Wrap:
/// two columns on phones, four columns on tablets / wide windows.
class CampusServiceGrid extends StatelessWidget {
  const CampusServiceGrid({
    super.key,
    required this.services,
    required this.onServiceTap,
  });

  final List<CampusService> services;
  final ValueChanged<CampusService> onServiceTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final columns = constraints.maxWidth >= 560 ? 4 : 2;
        final cardWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var i = 0; i < services.length; i++)
              // Cards in the same row appear one after another.
              Reveal(
                delay: Duration(milliseconds: 80 * (i % columns)),
                child: CampusActionCard(
                  service: services[i],
                  width: cardWidth,
                  onTap: () => onServiceTap(services[i]),
                ),
              ),
          ],
        );
      },
    );
  }
}
