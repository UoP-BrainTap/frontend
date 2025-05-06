import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages//faq.dart';

void main() {
  group('FAQpage Widget Tests', () {
    testWidgets('FAQ items are displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FAQpage()));

      expect(find.text("A"), findsOneWidget);
      expect(find.text("B"), findsNothing);
      expect(find.text("C"), findsOneWidget);
      expect(find.text("D"), findsNothing);
      expect(find.text("E"), findsOneWidget);
      expect(find.text("F"), findsNothing);
    });

    testWidgets('FAQ expands and collapses on tap', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FAQpage()));

      await tester.tap(find.text("A"));
      await tester.pumpAndSettle();

      expect(find.text("B"), findsOneWidget);

      await tester.tap(find.text("A"));
      await tester.pumpAndSettle();

      expect(find.text("B"), findsNothing);
    });

    testWidgets('Add FAQ button displays dialog', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FAQpage()));

      await tester.tap(find.text("Add FAQ"));
      await tester.pumpAndSettle();

      expect(find.text("Feature Coming Soon"), findsOneWidget);
      expect(find.text("This button can be used to add new FAQs!"), findsOneWidget);

      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      expect(find.text("Feature Coming Soon"), findsNothing);
    });
  });
}
