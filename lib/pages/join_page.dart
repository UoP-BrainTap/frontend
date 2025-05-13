import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:frontend/widgets/button.dart'; // Assuming you have ButtonWidget
import 'package:frontend/widgets/input.dart'; // Assuming you have CustomInputField

class JoinSessionPage extends StatefulWidget {
  const JoinSessionPage({super.key});

  @override
  State<JoinSessionPage> createState() => _JoinSessionPageState();
}

class _JoinSessionPageState extends State<JoinSessionPage> {
  final TextEditingController _sessionCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _joinSession() async {
    if (!_formKey.currentState!.validate()) return;

    final sessionCode = _sessionCodeController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dio = Provider.of<Dio>(context, listen: false);
      final response = await dio.get('/api/v1/sessions/$sessionCode');
      if (response.statusCode == 200) {
        context.go('/join/$sessionCode');
      } else {
        setState(() {
          _errorMessage = response.data['message'] ?? "Invalid session code.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to join session. Try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                    Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/web_icon.png',
                                        height: 55,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'BrainTap',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 44),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40),
                                  SizedBox(
                                    width:
                                        300, // Set the width here for the input
                                    child: CustomInputField(
                                      label: '',
                                      placeholder: 'Session ID',
                                      controller: _sessionCodeController,
                                      validator: (value) =>
                                          value == null || value.trim().isEmpty
                                              ? "Please enter a session code."
                                              : null,
                                    ),
                                  ),
                                  if (_errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        _errorMessage!,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width:
                                        300, // Set the width here for the button
                                    child: ButtonWidget(
                                      height: 50,
                                      borderRadius: 10,
                                      color: const Color(0xFF007BFF),
                                      text: _isLoading
                                          ? "Joining..."
                                          : "Join Session",
                                      onPressed: _joinSession,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/uni_logo.png',
                              height: 120,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    child: const Text(
                                      "Terms",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  "|",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    child: const Text(
                                      "Policy",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "© 2025 BrainTap. All rights reserved.",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.black54),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
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
