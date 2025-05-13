import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:frontend/pages/lecturer_page.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('LecturerPage Widget Tests', () {
    late GoRouter router;

    setUp(() {
      // Mock navigation for testing
      router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const LecturerPage(),
          ),
          GoRoute(
            path: '/lecturer/session',
            builder: (context, state) => const Scaffold(body: Text('Session Page')),
          ),
          GoRoute(
            path: '/lecturer/question/create',
            builder: (context, state) => const Scaffold(body: Text('Create Question Page')),
          ),
        ],
      );
    });

    testWidgets('should render Lecturer Dashboard with no questions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      expect(find.text('Lecturer Dashboard'), findsOneWidget);
      expect(find.text('No questions available'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(2)); // Create Session, Create Question
    });

    testWidgets('navigates to Create Session on button click', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      final createSessionButton = find.text('Create Session');
      expect(createSessionButton, findsOneWidget);

      await tester.tap(createSessionButton);
      await tester.pumpAndSettle();

      expect(find.text('Session Page'), findsOneWidget);
    });

    testWidgets('navigates to Create Question on button click', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      final createQuestionButton = find.text('Create Question');
      expect(createQuestionButton, findsOneWidget);

      await tester.tap(createQuestionButton);
      await tester.pumpAndSettle();

      expect(find.text('Create Question Page'), findsOneWidget);
    });

    testWidgets('displays questions when provided', (WidgetTester tester) async {
      final mockQuestions = [
        Question(id: 1, question: 'What is Flutter?'),
        Question(id: 2, question: 'Explain State Management'),
      ];

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          builder: (context, child) => ValueListenableBuilder<List<Question>>(
            valueListenable: ValueNotifier(mockQuestions),
            builder: (context, questions, child) {
              return LecturerPage(); // Use your widget here
            },
          ),
        ),
      );

      await tester.pump(); // Rebuild the widget with the provided questions

      expect(find.text('What is Flutter?'), findsOneWidget);
      expect(find.text('Explain State Management'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(4)); // Including Delete buttons (if any)
    });
  });
}
