import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page_landscape.dart';
import 'package:frontend/pages/home_page_portrait.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/signup_page.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          final screenWidth = MediaQuery.of(context).size.width;
          return screenWidth > 1000 // Adjust breakpoint as needed
              ? const HomeScreenLandscape()
              : const HomeScreenPortrait();
        },
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignupPage(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      routerConfig: _router,
    );
  }
}
