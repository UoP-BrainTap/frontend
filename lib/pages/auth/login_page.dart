import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/input.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(Dio dio, BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await dio.post('/auth/login', data: {
          'email': emailController.text,
          'password': passwordController.text,
        });

        if (response.statusCode == 200) {
          final shared = SharedPreferencesAsync();
          final data = jsonDecode(response.data);
          shared.setString('token', data['accessToken']);
          shared.setString('role', data['role']);
          shared.setInt('id', data['id']);
          context.go("/lecturer");
        }
      } catch (error) {
        if (error is DioException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Login failed: ${error.response?.data ?? 'Unknown error'}')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed: Unknown error')),
          );
        }
      }
    }
  }

  void _openTermsOfService() {
    // TODO: Navigate to Terms of Service page
    print("Terms of Service Clicked");
  }

  void _openPrivacyPolicy() {
    // TODO: Navigate to Privacy Policy page
    print("Privacy Policy Clicked");
  }

  @override
  Widget build(BuildContext context) {
    final dio = Provider.of<Dio>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (constraints.maxWidth > 1000)
                          Flexible(
                            flex: 1,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/login_photo.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
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
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    constraints.maxWidth > 1000 ? 120 : 30,
                                vertical: 20),
                            child: Center(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomInputField(
                                      label: "Email",
                                      controller: emailController,
                                      validator: (value) {
                                        return value != null &&
                                                EmailValidator.validate(value)
                                            ? null
                                            : 'Please enter a valid email';
                                      },
                                    ),
                                    CustomInputField(
                                      label: "Password",
                                      controller: passwordController,
                                      isPassword: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          "Forgot password?",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const Text(
                                            "By clicking Log in, you accept BrainTap's ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            " and ",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ),
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
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ButtonWidget(
                                      height: 60,
                                      borderRadius: 8.0,
                                      text: "Log in",
                                      onPressed: () => _login(dio, context),
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(height: 60),
                                    Center(
                                      child: Image.asset(
                                        'assets/images/uni_logo.png',
                                        height: 120,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: "Don't have an account? ",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            TextSpan(
                                              text: "Signup",
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    () => context.go("/signup"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        color: Colors.black12,
                        icon: const Icon(Icons.close,
                            size: 32, color: Colors.black),
                        onPressed: () {
                          context.go('/');
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
