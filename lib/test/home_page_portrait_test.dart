import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/home_page_portrait.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('HomeScreenPortrait Widget Tests', () {
    testWidgets('App bar displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreenPortrait(),
        ),
      );

      expect(find.text('BrainTap'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('Body content is displayed correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreenPortrait(),
        ),
      );

      expect(find.text("LET'S START THE GAME!"), findsOneWidget);
      expect(
          find.text('Dive into a World of Endless Trivia Fun'), findsOneWidget);
      expect(find.text('Play now'), findsOneWidget);
      expect(find.text('Create Your Quiz'), findsOneWidget);
    });

    testWidgets('Play now button navigates to /play',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreenPortrait(),
              ),
              GoRoute(
                path: '/play',
                builder: (context, state) => const Text('Play Screen'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Play now'));
      await tester.pumpAndSettle();

      expect(find.text('Play Screen'), findsOneWidget);
    });

    testWidgets('Create Your Quiz button navigates to /create-quiz',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreenPortrait(),
              ),
              GoRoute(
                path: '/create-quiz',
                builder: (context, state) => const Text('Create Quiz Screen'),
              ),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Create Your Quiz'));
      await tester.pumpAndSettle();

      expect(find.text('Create Quiz Screen'), findsOneWidget);
    });

    testWidgets('Footer contains correct text and actions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreenPortrait(),
        ),
      );

      expect(
          find.text('© 2025 BrainTap. All rights reserved.'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);

      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terms of Service'));
      await tester.pumpAndSettle();
    });
  });
}
