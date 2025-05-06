import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/home_page_landscape.dart';
import 'package:frontend/pages/home_page_portrait.dart';
import 'package:frontend/pages/auth/login_page.dart';
import 'package:frontend/pages/lecturer_page.dart';
import 'package:frontend/pages/session_lecturer_page.dart';
import 'package:frontend/pages/question_creation_page.dart';
import 'package:frontend/pages/question_managment_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  group('Main App Tests', () {
    testWidgets('renders HomeScreenPortrait on small screen', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 1280);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreenPortrait), findsOneWidget);
      expect(find.byType(HomeScreenLandscape), findsNothing);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('renders HomeScreenLandscape on large screen', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreenLandscape), findsOneWidget);
      expect(find.byType(HomeScreenPortrait), findsNothing);

      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('navigates to LoginPage when "/login" is visited', (WidgetTester tester) async {
      final GoRouter router = GoRouter(
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => LoginPage(),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(
        routerConfig: router,
      ));

      router.go('/login');
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('GoRouter renders nested lecturer page routes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider(create: (_) => DioProvider().dio),
            ChangeNotifierProvider(create: (_) => RefreshNotify()),
          ],
          child: MyApp(),
        ),
      );

      final router = GoRouter.of(tester.element(find.byType(MyApp)));
      router.go('/lecturer');
      await tester.pumpAndSettle();

      expect(find.byType(LecturerPage), findsOneWidget);

      router.go('/lecturer/session');
      await tester.pumpAndSettle();

      expect(find.byType(SessionLecturerPage), findsOneWidget);

      router.go('/lecturer/question/create');
      await tester.pumpAndSettle();

      expect(find.byType(QuestionCreationPage), findsOneWidget);

      router.go('/lecturer/question/manage');
      await tester.pumpAndSettle();

      expect(find.byType(QuestionManagementPage), findsOneWidget);
    });
  });
}
