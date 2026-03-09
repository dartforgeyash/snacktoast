import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snacktoast/snacktoast.dart';

void main() {
  setUp(() {
    SnackToastKit.reset();
  });

  group('SnackToastConfig', () {
    test('colorForType returns correct color for each type', () {
      const config = SnackToastConfig();

      // Values must match SnackToastConfig defaults exactly.
      expect(
        config.colorForType(SnackToastType.success),
        const Color(0xFF1B8A4A), // was 0xFF2E7D32 in old config
      );
      expect(
        config.colorForType(SnackToastType.error),
        const Color(0xFFD32F2F), // was 0xFFC62828 in old config
      );
      expect(
        config.colorForType(SnackToastType.warning),
        const Color(0xFFE65100),
      );
      expect(
        config.colorForType(SnackToastType.info),
        const Color(0xFF0277BD), // was 0xFF01579B in old config
      );
      expect(
        config.colorForType(SnackToastType.custom),
        const Color(0xFF37474F),
      );
    });

    test('copyWith preserves unmodified fields', () {
      const original = SnackToastConfig(maxQueueSize: 3);
      final modified = original.copyWith(maxQueueSize: 10);
      expect(modified.maxQueueSize, 10);
      expect(modified.defaultDuration, original.defaultDuration);
      expect(modified.visualStyle, original.visualStyle);
      expect(modified.animationStyle, original.animationStyle);
    });
  });

  group('SnackToastKit Toast', () {
    testWidgets('shows success toast in widget tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: SnackToastKit.navigatorKey,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SnackToastKit.toast(
                'Hello!',
                context: context,
                type: SnackToastType.success,
              ),
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));

      // pump() + explicit duration instead of pumpAndSettle():
      // Physics-based curves (elasticOut, bounceOut) used by scaleSpring and
      // bounceUp never fully "settle" within pumpAndSettle's idle window,
      // causing a timeout. Pumping a concrete duration is deterministic.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Hello!'), findsOneWidget);
    });

    testWidgets('dismissAll removes visible toasts', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: SnackToastKit.navigatorKey,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                // queued: true — enters the queue (may not display immediately)
                SnackToastKit.toast('Toast 1', context: context);
                // queued: false — bypasses queue, displays immediately
                SnackToastKit.toast(
                  'Toast 2',
                  context: context,
                  queued: false,
                );
              },
              child: const Text('Show'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      SnackToastKit.dismissAll();

      // After dismissAll triggers reverse animations, pump the exit duration.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Toast 1'), findsNothing);
    });
  });
}
