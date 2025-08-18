import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nfc_adventures/screens/scan_screen.dart';
import 'package:nfc_adventures/models/nfc_tag.dart';

void main() {
  group('ScanScreen Image Preview Tests', () {
    testWidgets('TagImagePreviewDialog displays tag name', (WidgetTester tester) async {
      final tag = ScannedNfcTag(
        uid: '32:b8:4e:d3',
        name: 'Test Tag',
        scannedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TagImagePreviewDialog(tag: tag),
          ),
        ),
      );

      expect(find.text('Test Tag'), findsOneWidget);
      expect(find.text('Tap to close'), findsOneWidget);
    });

    testWidgets('TagImagePreviewDialog can be dismissed by tap', (WidgetTester tester) async {
      final tag = ScannedNfcTag(
        uid: '32:b8:4e:d3',
        name: 'Test Tag',
        scannedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => TagImagePreviewDialog(tag: tag),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Show the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(TagImagePreviewDialog), findsOneWidget);

      // Tap anywhere to dismiss
      await tester.tap(find.byType(TagImagePreviewDialog));
      await tester.pumpAndSettle();

      expect(find.byType(TagImagePreviewDialog), findsNothing);
    });

    testWidgets('TagImagePreviewDialog auto-dismisses after 4 seconds', (WidgetTester tester) async {
      final tag = ScannedNfcTag(
        uid: '32:b8:4e:d3',
        name: 'Test Tag',
        scannedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => TagImagePreviewDialog(tag: tag),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Show the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(TagImagePreviewDialog), findsOneWidget);

      // Wait for auto-dismiss (4 seconds)
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(find.byType(TagImagePreviewDialog), findsNothing);
    });
  });
}