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

    expect(find.text('Quadrangle'), findsWidgets);
    expect(find.text('Aarav'), findsOneWidget);
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
}
