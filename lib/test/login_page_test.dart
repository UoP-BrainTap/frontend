import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:frontend/pages/auth/login_page.dart';

void main() {
  late GoRouter router;

  setUp(() {
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/signup',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Signup Page'))),
        ),
        GoRoute(
          path: '/lecturer',
          builder: (context, state) => const Scaffold(body: Center(child: Text('Lecturer Page'))),
        ),
      ],
    );
  });

  group('LoginPage Widget Tests', () {
    Future<void> pumpLoginPage(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<Dio>(
          create: (_) => Dio(),
          child: MaterialApp.router(routerConfig: router),
        ),
      );
    }

    testWidgets('renders LoginPage UI elements', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Signup'), findsOneWidget);
      expect(find.byType(MaterialButton), findsOneWidget);
    });

    testWidgets('validates email input', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pump();

      expect(find.text('Invalid email format'), findsOneWidget);

      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(find.text('Invalid email format'), findsNothing);
    });

    testWidgets('validates password input', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, '');
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);

      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      expect(find.text('Please enter your password'), findsNothing);
    });

    testWidgets('navigates to Signup on tapping Signup text', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      await tester.tap(find.text('Signup'));
      await tester.pumpAndSettle();

      expect(find.text('Signup Page'), findsOneWidget);
    });

    testWidgets('shows error on login failure', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      final dio = Provider.of<Dio>(tester.element(find.byType(LoginPage)), listen: false);
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioError(
                requestOptions: options,
                response: Response(
                  statusCode: 401,
                  requestOptions: options,
                  data: 'Invalid credentials',
                ),
              ),
            );
          },
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');
      await tester.tap(find.byType(MaterialButton));
      await tester.pump();

      expect(find.textContaining('Login failed: Invalid credentials'), findsOneWidget);
    });

    testWidgets('navigates to Lecturer page on successful login', (WidgetTester tester) async {
      await pumpLoginPage(tester);

      final dio = Provider.of<Dio>(tester.element(find.byType(LoginPage)), listen: false);
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {'accessToken': 'token', 'role': 'lecturer', 'id': 1},
              ),
            );
          },
        ),
      );

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'correctpassword');
      await tester.tap(find.byType(MaterialButton));
      await tester.pumpAndSettle();

      expect(find.text('Lecturer Page'), findsOneWidget);
    });
  });
}
