import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final bool _obscureText = true;

  String _password = '';
  String _email = '';

  _login(Dio dio) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      dio.post('/auth/login', data: {
        'email': _email,
        'password': _password,
      }).then((response) async {
        if (response.statusCode == 200) {
          var shared = await SharedPreferences.getInstance();
          Map data = jsonDecode(response.data);
          shared.setString('token', data['accessToken']);
          shared.setString('role', data['role']);
          shared.setInt('id', data['id']);
          context.go('/');
        }
      }).catchError((error) {
        if (error is DioException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${error.response}')),
          );
        } else {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed: Unknown error')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Login',
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return value != null && EmailValidator.validate(value)
                            ? null
                            : 'Please enter a valid email';
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: _obscureText,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                        onPressed: () {
                          _login(Provider.of<Dio>(context, listen: false));
                        },
                        color: Theme.of(context).highlightColor,
                        child: const Text('Login')),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(color: Colors.grey)),
                          TextSpan(
                              text: "Signup",
                              style: const TextStyle(color: Colors.white),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.go("/signup"))
                        ])),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }
}
