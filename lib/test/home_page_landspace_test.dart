import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/home_page_landscape.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HomeScreenLandscape Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('App bar displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SharedPreferences?>(
            create: (_) => null,
            child: const HomeScreenLandscape(),
          ),
        ),
      );

      expect(find.text('BrainTap'), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('Body text and buttons are displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SharedPreferences?>(
            create: (_) => null,
            child: const HomeScreenLandscape(),
          ),
        ),
      );

      expect(find.text("LET'S START THE GAME!"), findsOneWidget);
      expect(find.text('Dive into a World of Endless Trivia Fun'), findsOneWidget);
      expect(find.text('Play now'), findsOneWidget);
      expect(find.text('Create Your Quiz'), findsOneWidget);
    });

    testWidgets('Navigation to /play works on Play now button tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SharedPreferences?>(
            create: (_) => null,
            child: const HomeScreenLandscape(),
          ),
        ),
      );

      await tester.tap(find.text('Play now'));
      await tester.pumpAndSettle();
    });

    testWidgets('Logged-in user actions are displayed', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({'token': 'testToken'});

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SharedPreferences?>(
            create: (_) => SharedPreferences.getInstance() as SharedPreferences?,
            child: const HomeScreenLandscape(),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
      expect(find.text('Log in'), findsNothing);
      expect(find.text('Sign up'), findsNothing);
    });

    testWidgets('Logged-out user actions are displayed', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SharedPreferences?>(
            create: (_) => SharedPreferences.getInstance() as SharedPreferences?,
            child: const HomeScreenLandscape(),
          ),
        ),
      );

      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      expect(find.text('Dashboard'), findsNothing);
      expect(find.text('Logout'), findsNothing);
    });

    testWidgets('Footer contains correct text and actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const HomeScreenLandscape(),
        ),
      );

      expect(find.text('© 2025 BrainTap. All rights reserved.'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);

      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terms of Service'));
      await tester.pumpAndSettle();
    });
  });
}
