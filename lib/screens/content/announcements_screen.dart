import 'package:flutter/material.dart';

import '../../data/campus_content_data.dart';
import '../../models/campus_content.dart';
import '../../theme/app_theme.dart';
import 'announcement_detail_screen.dart';

/// Scrollable list of campus announcements with bookmarks.
///
/// [bookmarkedIds] lives in this State (outside build), and this screen stays
/// mounted while a detail page is pushed on top of it, so bookmarks survive
/// opening and closing an announcement.
class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  final Set<String> bookmarkedIds = {};

  static const _icons = {
    'Academic': Icons.school_rounded,
    'Facilities': Icons.local_library_rounded,
    'Careers': Icons.work_outline_rounded,
    'Transport': Icons.directions_bus_rounded,
    'Wellbeing': Icons.self_improvement_rounded,
    'IT Services': Icons.wifi_rounded,
    'Sports': Icons.sports_soccer_rounded,
    'Accommodation': Icons.apartment_rounded,
  };

  void _toggle(String id) => setState(() {
    bookmarkedIds.contains(id)
        ? bookmarkedIds.remove(id)
        : bookmarkedIds.add(id);
  });

  @override
  Widget build(BuildContext context) {
    const items = CampusContentData.announcements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${bookmarkedIds.length} saved',
                style: const TextStyle(color: AppColors.oatmeal),
              ),
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(
              12,
              12,
              12,
              24 + MediaQuery.paddingOf(context).bottom,
            ),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const Padding(
                  padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
                  child: Text(
                    'Demonstration data · tap a card to read it, '
                    'or the bookmark to save it',
                    style: TextStyle(fontSize: 12.5, color: AppColors.muted),
                  ),
                );
              }
              final item = items[index - 1];
              final saved = bookmarkedIds.contains(item.id);
              return Card(
                color: AppColors.surface,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: AppStyle.cardRadius,
                  side: const BorderSide(color: AppColors.line),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.parchment,
                    child: Icon(
                      _icons[item.category] ?? Icons.campaign_rounded,
                      color: AppColors.navy,
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    '${item.category} • ${item.date}\n${item.preview}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: saved ? 'Remove bookmark' : 'Bookmark',
                    icon: Icon(
                      saved ? Icons.bookmark : Icons.bookmark_border,
                      color: saved ? AppColors.truffle : AppColors.muted,
                    ),
                    onPressed: () => _toggle(item.id),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnnouncementDetailScreen(
                        item: item,
                        bookmarked: saved,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
