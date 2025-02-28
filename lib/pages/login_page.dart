import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/button.dart';
import '../widgets/input.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  void _openTermsOfService() {
    // TODO: Implement navigation to Terms of Service page
    print("Terms of Service Clicked");
  }

  void _openPrivacyPolicy() {
    // TODO: Implement navigation to Privacy Policy page
    print("Privacy Policy Clicked");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Side: Image (Only on large screens)
                        if (constraints.maxWidth > 1000)
                          Flexible(
                            flex: 1,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/login_photo.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // BrainTap Logo in the Top Left
                                const Positioned(
                                  top: 50,
                                  left: 60,
                                  child: Text(
                                    "BrainTap",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 56,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Right Side: Login Form
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomInputField(
                                    label: "Email",
                                    controller: emailController,
                                  ),
                                  CustomInputField(
                                    label: "Password",
                                    controller: passwordController,
                                    isPassword: true,
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        "Forgot password?",
                                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Terms & Privacy Policy Links
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "By clicking Log in, you accept BrainTap's ",
                                        style: TextStyle(fontSize: 14, color: Colors.black54),
                                      ),

                                      // Terms of Service (Clickable)
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: _openTermsOfService,
                                          child: const Text(
                                            "Terms of Service",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const Text(
                                        " and ",
                                        style: TextStyle(fontSize: 14, color: Colors.black54),
                                      ),

                                      // Privacy Policy (Clickable)
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: _openPrivacyPolicy,
                                          child: const Text(
                                            "Privacy Policy",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),
                                  ButtonWidget(
                                    height: 60,
                                    borderRadius: 8.0,
                                    text: "Log in",
                                    onPressed: () {},
                                    color: Colors.blue,
                                  ),

                                  // University Logo BELOW the Login Button
                                  const SizedBox(height: 60),
                                  Center(
                                    child: Image.asset(
                                      'assets/images/uni_logo.png',
                                      height: 120,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // X Button in the Top Right Corner
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        color: Colors.black12,
                        icon: const Icon(Icons.close, size: 32, color: Colors.black),
                        onPressed: () {
                          context.go('/'); // Navigate back to home page
                        },
                        tooltip: "Back to Home",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}