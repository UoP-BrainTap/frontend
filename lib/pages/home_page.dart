import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Row(
          children: [
            const SizedBox(width: 40),
            Image.asset(
              'assets/images/web_icon.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'BrainTap',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 32),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const SizedBox(width: 20),
          ButtonWidget(
            text: "Log in",
            onPressed: () {
              context.go('/login');
            },
            isOutlined: true,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          ButtonWidget(
            text: "Sign up",
            onPressed: () {
              context.go('/signup');
            },
            color: Colors.deepPurple,
            textColor: Colors.white,
          ),
          const SizedBox(width: 50),
          ButtonWidget(text: "FAQ", onPressed: (){
            context.go('/FAQ');
          },
            color: Colors.black,
            textColor: Colors.white,
          ),
          const SizedBox(width: 90),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2), // Border thickness
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60), // Padding on both sides
            child: Opacity(
              opacity: 0.5, // Adjust opacity (0 = fully transparent, 1 = fully visible)
              child: Container(
                color: Colors.black, // Border color
                height: 2, // Border thickness
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 100), // Adds top padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the top
          children: [
            // Left Side: Text Content
            Expanded(
              child: SingleChildScrollView( // Add this to prevent overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "LET'S START THE GAME!",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Dive into a World of Endless Trivia Fun",
                      style: TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Get ready for an epic journey filled with exciting challenges and mind-boggling questions. "
                          "Whether you're a casual player or a seasoned quiz master, there's always something new to discover!",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        ButtonWidget(
                          text: "Play now",
                          onPressed: () {
                            context.go('/play');
                          },
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                        ),
                        const SizedBox(width: 20),
                        TextButton(
                          onPressed: () {
                            context.go('/create-quiz');
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
                              const SizedBox(height: 5), // Space between text and underline
                              Container(
                                width: 130, // Match text width
                                height: 2, // Thickness of underline
                                color: Colors.deepPurple, // Underline color
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Right Side: Image
            Expanded(
              child: Align(
                alignment: Alignment.topCenter, // Aligns image to the top
                child: Image.asset(
                  'assets/images/home_page_photo.png',
                  width: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}