import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/button.dart';

class HomeScreenLandscape extends StatefulWidget {
  const HomeScreenLandscape({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenLandscapeState();
  }
}

class HomeScreenLandscapeState extends State<HomeScreenLandscape> {
  @override
  Widget build(BuildContext context) {
    var _ = Provider.of<RefreshNotify>(context);
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
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  fontSize: 32),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: (() {
          var shared = Provider.of<SharedPreferencesWithCache?>(context);
          if (shared != null && shared.getString('token') != null) {
            return [
              ButtonWidget(
                width: 200,
                text: "Dashboard",
                onPressed: () {
                  context.go('/lecturer');
                },
                color: Colors.deepPurple,
                textColor: Colors.white,
              ),
              const SizedBox(width: 10),
              ButtonWidget(
                width: 110,
                text: "Logout",
                onPressed: () {
                  shared.remove('token');
                  shared.remove('role');
                  shared.remove('id');
                  setState(() {});
                },
                isOutlined: true,
                color: Colors.black,
              ),
            ];
          } else {
            return [
              const SizedBox(width: 20),
              ButtonWidget(
                width: 110,
                text: "Log in",
                onPressed: () {
                  context.go('/login');
                },
                isOutlined: true,
                color: Colors.black,
              ),
              const SizedBox(width: 10),
              ButtonWidget(
                width: 110,
                text: "Sign up",
                onPressed: () {
                  context.go('/signup');
                },
                color: Colors.deepPurple,
                textColor: Colors.white,
              ),
              const SizedBox(width: 50),
            ];
          }
        })(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Opacity(
              opacity: 0.5,
              child: Container(
                color: Colors.black,
                height: 2,
              ),
            ),
          ),
        ),
      ),

      // Scrollable Body with Row Layout
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Side: Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LET'S START THE GAME!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepPurple),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Dive into a World of Endless Trivia Fun",
                      style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
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
                          width: 130,
                          text: "Play now",
                          onPressed: () {
                            context.go('/join');
                          },
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                        ),
                        const SizedBox(width: 20),
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
                      ],
                    ),
                    const SizedBox(
                        height: 40), // Prevents text from being too close
                  ],
                ),
              ),
              const SizedBox(width: 40), // Space between text and image

              // Right Side: Image (Kept Fixed)
              SizedBox(
                width: 400, // Adjust width as needed
                child: Image.asset(
                  'assets/images/home_page_photo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom AppBar
      bottomNavigationBar: SizedBox(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Black border at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Opacity(
                opacity: 0.5,
                child: Container(
                  height: 2,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: BottomAppBar(
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left: Copyright
                      const Text(
                        "© 2025 BrainTap. All rights reserved.",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                      // Center: University logo
                      Image.asset(
                        'assets/images/uni_logo.png',
                        height: 100,
                      ),
                      // Right: Privacy Policy and Terms
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Privacy Policy",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Terms of Service",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
