import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/question_managment_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuestionManagementPage', () {
    testWidgets('displays the app bar title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionManagementPage(),
        ),
      );

      expect(find.text('Manage Questions'), findsOneWidget);
    });

    testWidgets('displays the questions placeholder text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionManagementPage(),
        ),
      );

      expect(find.text('Questions will be displayed here'), findsOneWidget);
    });

    testWidgets('displays multiple choice question entries',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: QuestionManagementPage(),
        ),
      );

      expect(find.byType(MultipleChoiceQuestionEntry), findsNWidgets(9));
    });

    testWidgets('navigates to question management page on tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const QuestionManagementPage(),
          routes: {
            '/question/manage/1': (context) =>
                const Scaffold(body: Text('Question Management')),
          },
        ),
      );

      final questionEntry = find.byType(MultipleChoiceQuestionEntry).first;
      await tester.tap(questionEntry);
      await tester.pumpAndSettle();

      expect(find.text('Question Management'), findsOneWidget);
    });
  });
}
