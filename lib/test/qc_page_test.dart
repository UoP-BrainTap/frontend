import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/question_creation_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuestionCreationPage', () {
    testWidgets('displays the app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionCreationPage(),
        ),
      );

      expect(find.text('Create a Question'), findsOneWidget);
    });

    testWidgets('displays question type selectors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionCreationPage(),
        ),
      );

      expect(find.text('Multiple Choice'), findsOneWidget);
      expect(find.text('Short Text'), findsOneWidget);
    });

    testWidgets(
        'displays MultipleChoiceQuestionCreation when multiple choice is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionCreationPage(),
        ),
      );

      await tester.tap(find.text('Multiple Choice'));
      await tester.pumpAndSettle();

      expect(find.byType(MultipleChoiceQuestionCreation), findsOneWidget);
    });

    testWidgets('adds an option when "Add Option" button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionCreationPage(),
        ),
      );

      await tester.tap(find.text('Multiple Choice'));
      await tester.pumpAndSettle();

      expect(find.byType(MultipleChoiceOptionWidget), findsOneWidget);

      await tester.tap(find.text('Add Option'));
      await tester.pumpAndSettle();

      expect(find.byType(MultipleChoiceOptionWidget), findsNWidgets(2));
    });

    testWidgets('validates question title input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionCreationPage(),
        ),
      );

      await tester.tap(find.text('Multiple Choice'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Question'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a question title'), findsOneWidget);
    });
  });
}
