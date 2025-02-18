import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brain Tap'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: MaterialButton(
              color: Theme.of(context).highlightColor,
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Login'),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text("Lorem IPSUM"),
      ),
    );
  }
}