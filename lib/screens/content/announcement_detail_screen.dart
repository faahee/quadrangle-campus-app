import 'package:flutter/material.dart';

import '../../models/campus_content.dart';
import '../../theme/app_theme.dart';

/// Full view of the [Announcement] that was tapped.
class AnnouncementDetailScreen extends StatelessWidget {
  const AnnouncementDetailScreen({
    super.key,
    required this.item,
    this.bookmarked = false,
  });

  final Announcement item;
  final bool bookmarked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.category)),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 760),
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              32 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppStyle.heading.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text(item.category)),
                    Chip(
                      avatar: const Icon(Icons.event_rounded, size: 18),
                      label: Text(item.date),
                    ),
                    if (bookmarked)
                      const Chip(
                        avatar: Icon(Icons.bookmark, size: 18),
                        label: Text('Bookmarked'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  item.detail,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Demonstration data',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
