import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_campus_app/main.dart';

/// Pumps the app at a given logical size with "reduce motion" switched on,
/// so reveal / floating / marquee animations don't make tests flaky.
Future<void> pumpApp(
  WidgetTester tester, {
  Size size = const Size(390, 844),
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  tester.platformDispatcher.accessibilityFeaturesTestValue =
      const FakeAccessibilityFeatures(disableAnimations: true);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);

  await tester.pumpWidget(const QuadrangleApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Dashboard shows all required sections', (tester) async {
    await pumpApp(tester);

    expect(find.text('MIT Campus'), findsWidgets);
    expect(find.text('Mark'), findsOneWidget);
    expect(find.text('Academic snapshot'), findsOneWidget);
    expect(find.text('Quick access'), findsOneWidget);
    expect(find.text('Timetable'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Campus update'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Campus update'), findsOneWidget);
  });

  testWidgets('Tapping a service card opens its page', (tester) async {
    await pumpApp(tester);

    // Bring the card to mid-screen (clear of the floating nav bar).
    await Scrollable.ensureVisible(
      tester.element(find.text('Library')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('Book a study room'), findsOneWidget);

    await tester.tap(find.text('Renew').first);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Floating navigation switches tabs', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();
    expect(find.text('Campus alerts'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('My profile'), findsOneWidget);
  });

  testWidgets('Centre button opens quick actions', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.bySemanticsLabel('Quick actions'));
    await tester.pumpAndSettle();
    expect(find.text('Pay fees'), findsOneWidget);

    await tester.tap(find.text('Pay fees'));
    await tester.pumpAndSettle();
    expect(find.text('Fees & payments'), findsOneWidget);
  });

  testWidgets('Desktop width uses the two-column layout', (tester) async {
    await pumpApp(tester, size: const Size(1440, 900));

    expect(find.text('Your day at a glance'), findsOneWidget);
    expect(find.text('Latest alerts'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Pages open inside the tab, keeping the nav bar', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fees'));
    await tester.pumpAndSettle();

    expect(find.text('Fees & payments'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget); // floating nav still shown

    // Tapping the active tab again pops back to its first page.
    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    expect(find.text('Campus services'), findsOneWidget);
  });

  testWidgets('Request form validates and submits', (tester) async {
    await pumpApp(tester);

    Future<void> show(Finder f) async {
      await Scrollable.ensureVisible(tester.element(f), alignment: 0.4);
      await tester.pumpAndSettle();
    }

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();
    await show(find.text('Requests'));
    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New request'));
    await tester.pumpAndSettle();
    expect(find.text('Your details'), findsOneWidget);

    // Submitting an empty form shows the validation messages.
    await show(find.text('Submit request'));
    await tester.tap(find.text('Submit request'));
    await tester.pumpAndSettle();
    expect(find.text('Please confirm before submitting'), findsOneWidget);
    expect(find.text('Pick a date'), findsOneWidget);

    // Fill in every required field.
    await show(find.text('IT support'));
    await tester.tap(find.text('IT support'));
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Subject'),
      'Laptop cannot print',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Details'),
      'The library printers reject my student login every time.',
    );
    await show(find.text('Needed by'));
    await tester.tap(find.text('Needed by'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await show(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    await show(find.text('Submit request'));
    await tester.tap(find.text('Submit request'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Request submitted'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Laptop cannot print'), findsOneWidget);
  });
}
