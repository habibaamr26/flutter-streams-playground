import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stream_test/main.dart';

void main() {
  testWidgets('adding a blog shows it in the list and updates the count', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Starts empty.
    expect(find.text('No data available'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Open the sheet, type, submit.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'First blog');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('First blog'), findsOneWidget);
    expect(find.text('No data available'), findsNothing);
  });
}
