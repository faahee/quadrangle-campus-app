import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_campus_app/data/campus_content_data.dart';
import 'package:student_campus_app/main.dart';
import 'package:student_campus_app/services/local_store.dart';

/// Lab "Campus Content Lists and Grids" – Task 5 test table.
Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  SharedPreferences.setMockInitialValues({});
  await LocalStore.init();
  await tester.pumpWidget(const QuadrangleApp());
  await tester.pumpAndSettle();
}

Future<void> openFromServicesTab(WidgetTester tester, String card) async {
  await tester.tap(find.text('Services'));
  await tester.pumpAndSettle();
  await tester.tap(find.text(card));
  await tester.pumpAndSettle();
}

Finder cardFor(String title) =>
    find.ancestor(of: find.text(title), matching: find.byType(Card));

void main() {
  const items = CampusContentData.announcements;

  test('8 announcements and 6 services with unique ids', () {
    expect(items.length, 8);
    expect(items.map((a) => a.id).toSet().length, 8);
    expect(CampusContentData.services.length, 6);
    expect(CampusContentData.services.map((s) => s.id).toSet().length, 6);
  });

  testWidgets('Scroll to announcement 8, open it and go back', (tester) async {
    await pumpApp(tester);
    await openFromServicesTab(tester, 'Announcements');

    await tester.scrollUntilVisible(find.text(items[7].title), 200);
    await tester.tap(find.text(items[7].title));
    await tester.pumpAndSettle();
    expect(find.text(items[7].detail), findsOneWidget);
    expect(find.text(items[0].detail), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Announcements'), findsOneWidget);
    expect(find.text(items[7].title), findsOneWidget);
  });

  testWidgets('Bookmark announcement 2 survives opening its details',
      (tester) async {
    await pumpApp(tester);
    await openFromServicesTab(tester, 'Announcements');

    final second = cardFor(items[1].title);
    await tester.tap(find.descendant(
        of: second, matching: find.byIcon(Icons.bookmark_border)));
    await tester.pumpAndSettle();
    expect(find.descendant(of: second, matching: find.byIcon(Icons.bookmark)),
        findsOneWidget);

    await tester.tap(find.text(items[1].title));
    await tester.pumpAndSettle();
    expect(find.text('Bookmarked'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(
        find.descendant(
            of: cardFor(items[1].title), matching: find.byIcon(Icons.bookmark)),
        findsOneWidget);
    expect(find.text('1 saved'), findsOneWidget);
  });

  testWidgets('Each of the six service tiles opens its page', (tester) async {
    await pumpApp(tester);
    await openFromServicesTab(tester, 'Student services');

    const expected = {
      'Library': 'Book a study room',
      'Counselling': 'Sample detail · demonstration data',
      'Accommodation': 'Sample detail · demonstration data',
      'Career Services': 'Sample detail · demonstration data',
      'Sports': 'Sample detail · demonstration data',
      'IT Helpdesk': 'Requests & support',
    };
    for (final entry in expected.entries) {
      await tester.tap(find.bySemanticsLabel('Open ${entry.key}'));
      await tester.pumpAndSettle();
      expect(find.text(entry.value), findsOneWidget, reason: entry.key);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });

  for (final (name, size, scale) in [
    ('narrow 320px', const Size(320, 700), 1.0),
    ('tablet 768px', const Size(768, 1024), 1.0),
    ('desktop 1280px', const Size(1280, 800), 1.0),
    ('narrow with 1.5x text', const Size(360, 780), 1.5),
  ]) {
    testWidgets('No overflow on $name', (tester) async {
      await pumpApp(tester, size: size, textScale: scale);
      await openFromServicesTab(tester, 'Student services');
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Announcements'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
