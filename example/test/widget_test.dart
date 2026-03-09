import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';
import 'package:snacktoast/snacktoast.dart';

void main() {
  setUp(() {
    SnackToastKit.reset();
  });

  group('Example App v2.1.0 Widget Tests', () {
    testWidgets('Header renders', (WidgetTester tester) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pump();
      expect(find.text('SNACKTOAST / DEMO'), findsOneWidget);
    });

    testWidgets('Live config toggles update global state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Initially it should be true (default)
      expect(SnackToastKit.config.showProgressBar, isTrue);

      final progressBarToggle = find.text('Progress Bar');
      await tester.tap(progressBarToggle);
      await tester.pumpAndSettle();

      expect(SnackToastKit.config.showProgressBar, isFalse);
    });

    testWidgets('Visual Style picker updates global state', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      final glassStyleBtn = find.text('glass');
      await tester.tap(glassStyleBtn);
      await tester.pumpAndSettle();

      expect(SnackToastKit.config.visualStyle, SnackToastVisualStyle.glass);
    });

    testWidgets('Animation family labels are present', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Scroll to find it
      final scrollable = find.byType(Scrollable).first;
      final verticalOriginText = find.text('Vertical Origin');

      await tester.scrollUntilVisible(
        verticalOriginText,
        200.0,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();

      expect(verticalOriginText, findsOneWidget);
    });

    testWidgets('Tapping centerPop triggers focused toast', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      final popBtn = find.text('Center Pop');
      final scrollable = find.byType(Scrollable).first;

      await tester.scrollUntilVisible(popBtn, 200.0, scrollable: scrollable);
      await tester.pumpAndSettle();

      expect(popBtn, findsOneWidget);

      await tester.tap(popBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.text('Focus pop!'), findsOneWidget);
    });

    testWidgets('Dismiss All button clears visibility', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      SnackToastKit.success('Toast 1');
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Toast 1'), findsOneWidget);

      final clearBtn = find.text('Clear');
      await tester.tap(clearBtn);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Toast 1'), findsNothing);
    });
  });
}
