import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_campus_app/main.dart';

void main() {
  testWidgets('Dashboard shows all required sections', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const QuadrangleApp());
    await tester.pumpAndSettle();

    expect(find.text('Quadrangle'), findsOneWidget);
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
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const QuadrangleApp());
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Library'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Library'));
    await tester.pumpAndSettle();
    expect(find.text('Book a study room'), findsOneWidget);

    await tester.tap(find.text('Renew').first);
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('Bottom navigation switches tabs', (tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const QuadrangleApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Alerts'));
    await tester.pumpAndSettle();
    expect(find.text('Campus alerts'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('My profile'), findsOneWidget);
  });
}
