import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/button.dart';

class HomeScreenPortrait extends StatelessWidget {
  const HomeScreenPortrait({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            Image.asset(
              'assets/images/web_icon.png',
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text(
              'BrainTap',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          ButtonWidget(
            height: 45,
            textSize: 14,
            width: 100,
            text: "Log in",
            onPressed: () {
              context.go('/login');
            },
            isOutlined: true,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "LET'S START THE GAME!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Dive into a World of Endless Trivia Fun",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Get ready for an epic journey filled with exciting challenges and mind-boggling questions. "
                      "Whether you're a casual player or a seasoned quiz master, there's always something new to discover!",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 30),
                    ButtonWidget(
                      width: 150,
                      text: "Play now",
                      onPressed: () {
                        context.go('/join');
                      },
                      color: Colors.deepPurple,
                      textColor: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        context.go('/lecturer/question/create');
                      },
                      child: Column(
                        children: [
                          const Text(
                            "Create Your Quiz",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 130,
                            height: 2,
                            color: Colors.deepPurple,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Image.asset(
                      'assets/images/home_page_photo.png',
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "© 2025 BrainTap. All rights reserved.",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    const SizedBox(width: 15),
                    Image.asset(
                      'assets/images/uni_logo.png',
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Privacy Policy",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 15),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Terms of Service",
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
