import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/input.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing up...')),
      );

      // Add signup logic here
    }
  }

  void _openTermsOfService() {
    print("Terms of Service Clicked");
  }

  void _openPrivacyPolicy() {
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
                                      validator: (value) => value != null &&
                                              EmailValidator.validate(value)
                                          ? null
                                          : 'Please enter a valid email',
                                    ),
                                    CustomInputField(
                                      label: "Password",
                                      controller: passwordController,
                                      isPassword: true,
                                      validator: (value) =>
                                          value == null || value.isEmpty
                                              ? 'Please enter your password'
                                              : null,
                                    ),
                                    CustomInputField(
                                      label: "Confirm Password",
                                      controller: confirmPasswordController,
                                      isPassword: true,
                                      validator: (value) =>
                                          value != passwordController.text
                                              ? 'Passwords do not match'
                                              : null,
                                    ),
                                    const SizedBox(height: 20),
                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const Text(
                                            "By signing up, you accept BrainTap's ",
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
                                      text: "Sign up",
                                      onPressed: _signup,
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
                                              text: "Already have an account? ",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            TextSpan(
                                              text: "Login",
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    () => context.go("/login"),
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
                        onPressed: () => context.go('/'),
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
