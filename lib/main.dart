import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/signup_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:dio/dio.dart';

void main() {
  setPathUrlStrategy();
  runApp(MultiProvider(providers: [
    // ChangeNotifierProvider(create: (context) => AuthProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'signup',
            builder: (context, state) => const SignupPage(),
          ),
        ]
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Provider<Dio>(
      create: (_) => DioProvider().dio,
      child: MaterialApp.router(
        theme: ThemeData(
          fontFamily: 'Poppins',
          brightness: Brightness.dark,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

class DioProvider {
  Dio get dio {
    var instance = Dio();
    instance.options.baseUrl = 'http://localhost:8080';
    instance.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // get access token from shared preferences
          var shared = await SharedPreferences.getInstance();
          var token = shared.getString('accessToken');
          if (token == null || token.isEmpty) {
            handler.next(options);
            return;
          }

          // add token to headers
          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        }
      )
    );
    return instance;
  }
}
