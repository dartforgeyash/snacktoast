import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snacktoast/snacktoast.dart';

void main() {
  setUp(() {
    // Reset static state between tests. Prevents key/queue leakage across
    // test cases, which causes flaky failures when tests run in sequence.
    SnackToastKit.reset();
  });

  testWidgets('snackbarSuccess displays message correctly',
      (WidgetTester tester) async {
    const testMessage = 'Success from SnackToast!';

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: SnackToastKit.scaffoldMessengerKey,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  SnackToastKit.snackbarSuccess(testMessage, context: context),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump(); // Starts the SnackBar entrance animation frame.

    expect(find.text(testMessage), findsOneWidget);
  });

  testWidgets('snackbarError displays message correctly',
      (WidgetTester tester) async {
    const testMessage = 'Error occurred!';

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey: SnackToastKit.scaffoldMessengerKey,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () =>
                  SnackToastKit.snackbarError(testMessage, context: context),
              child: const Text('Show'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(find.text(testMessage), findsOneWidget);
  });
}
