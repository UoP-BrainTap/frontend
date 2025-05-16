import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:frontend/pages/join_page.dart';
import 'package:provider/provider.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('JoinSessionPage Widget Tests', () {
    testWidgets('Renders input field and join button correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<Dio>(
            create: (_) => Dio(),
            child: const JoinSessionPage(),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text("Join Session"), findsOneWidget);
    });

    testWidgets('Displays error message if session code is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<Dio>(
            create: (_) => Dio(),
            child: const JoinSessionPage(),
          ),
        ),
      );

      await tester.tap(find.text("Join Session"));
      await tester.pumpAndSettle();
      expect(find.text("Please enter a session code."), findsOneWidget);
    });

    testWidgets('Calls API and navigates on valid session code',
        (WidgetTester tester) async {
      final mockDio = MockDio();
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 200,
                requestOptions: RequestOptions(path: '/quiz/join'),
              ));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<Dio>(
            create: (_) => mockDio,
            child: const JoinSessionPage(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '12345');
      await tester.tap(find.text("Join Session"));
      await tester.pumpAndSettle();
      expect(find.text("Join a Quiz Session"), findsNothing);
    });

    testWidgets('Displays error message on API failure',
        (WidgetTester tester) async {
      final mockDio = MockDio();
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {'message': 'Invalid session code.'},
                statusCode: 400,
                requestOptions: RequestOptions(path: '/quiz/join'),
              ));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<Dio>(
            create: (_) => mockDio,
            child: const JoinSessionPage(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'invalid_code');
      await tester.tap(find.text("Join Session"));
      await tester.pumpAndSettle();
      expect(find.text("Invalid session code."), findsOneWidget);
    });
  });
}
