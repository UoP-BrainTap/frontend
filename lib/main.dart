import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page_landscape.dart';
import 'package:frontend/pages/home_page_portrait.dart';
//import 'package:frontend/pages/QC_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/question_creation_page.dart';
import 'package:frontend/pages/question_managment_page.dart';
import 'package:frontend/pages/signup_page.dart';
import 'package:frontend/pages/faq.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:dio/dio.dart';

void main() {
  setPathUrlStrategy();
  // runApp(MultiProvider(providers: [
  //   // ChangeNotifierProvider(create: (context) => AuthProvider()),
  // ], child: MyApp()));
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
            GoRoute(
              path: 'FAQ',
              builder: (context, state) => FAQpage(),
            ),
            GoRoute(
              path: 'question',
              redirect: (_, state) {
                if (state.uri.toString().endsWith("question")) {
                  return '/';
                }
                return null;
              },
           routes: [
             GoRoute(
               path: 'create',
               builder: (context, state) => const QuestionCreationPage(),
             ),
             GoRoute(
               path: 'manage',
                builder: (context, state) => const QuestionManagementPage(),
             )
           ]
            )
          ]),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Provider<Dio>(
      create: (_) => DioProvider().dio,
      child: MaterialApp.router(
        theme: ThemeData(
          fontFamily: 'Poppins',
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
    instance.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
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
    }));
    return instance;
  }
}
