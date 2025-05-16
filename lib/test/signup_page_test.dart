import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/auth/signup_page.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

void main() {
  group('SignupPage Widget Tests', () {
    testWidgets(
        'should show form with email, password, and confirm password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SignupPage(),
        ),
      );

      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byType(MaterialButton), findsOneWidget);
    });

    testWidgets('should show error when email is invalid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SignupPage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'invalid-email');
      await tester.pump();
      await tester.tap(find.byType(MaterialButton));
      await tester.pump();
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SignupPage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password124');
      await tester.pump();
      await tester.tap(find.byType(MaterialButton));
      await tester.pump();
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should show no error when passwords match and email is valid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SignupPage(),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'test@test.com');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.enterText(find.byType(TextFormField).at(2), 'password123');
      await tester.pump();
      await tester.tap(find.byType(MaterialButton));
      await tester.pump();
      expect(find.text('Passwords do not match'), findsNothing);
    });

    testWidgets('should show PasswordStrengthChecker and update strength',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const SignupPage(),
        ),
      );

      final passwordStrengthNotifier = ValueNotifier<PasswordStrength?>(null);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthChecker(strength: passwordStrengthNotifier),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(1), '123');
      await tester.pump();

      expect(passwordStrengthNotifier.value?.strength, equals(1));

      await tester.enterText(
          find.byType(TextFormField).at(1), 'Str0ngP@ssw0rd!');
      await tester.pump();

      expect(passwordStrengthNotifier.value?.strength, equals(4));
    });
  });
}

extension on PasswordStrength? {
  get strength => null;
}
