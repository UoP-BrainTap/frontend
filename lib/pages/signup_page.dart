import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {

  final _formKey = GlobalKey<FormState>();
  final bool _obscureText = true;
  final _passNotifier = ValueNotifier<PasswordStrength?>(null);

  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value != null && EmailValidator.validate(value) ? null : 'Please enter a valid email';
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: _obscureText,
                      onChanged: (value) {
                        setState(() {
                          _passNotifier.value = PasswordStrength.calculate(text: value);
                          _password = value;
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      obscureText: _obscureText,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    PasswordStrengthChecker(
                      strength: _passNotifier,
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Signing up...'))
                            );
                          }
                        },
                        color: Theme.of(context).highlightColor,
                        child: const Text('Signup')
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(text: TextSpan(
                            children: [
                              const TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(color: Colors.grey)
                              ),
                              TextSpan(
                                  text: "Login",
                                  style: const TextStyle(color: Colors.white),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context.go("/login")
                              )
                            ]
                        )),
                      ],
                    )
                  ],
                ),
              )
          )
      ),
    );
  }
}