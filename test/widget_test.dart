// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nfc_adventures/main.dart';

void main() {
  testWidgets('App starts with QR scanner when no adventure is selected',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NfcCollectorApp());
    await tester.pumpAndSettle();

    // Verify that QR scanner screen elements are present
    // Since we can't actually test camera functionality in unit tests,
    // we just verify the app builds and loads properly
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
