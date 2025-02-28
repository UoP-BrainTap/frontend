import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

class JoinSessionPage extends StatefulWidget {
  const JoinSessionPage({super.key});

  @override
  JoinSessionPageState createState() => JoinSessionPageState();
}

class JoinSessionPageState extends State<JoinSessionPage> {
  final TextEditingController _sessionCodeController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _joinSession() async {
    final sessionCode = _sessionCodeController.text.trim();
    if (sessionCode.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a session code.";
      });
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      final dio = Provider.of<Dio>(context, listen: false);
      final response = await dio.post('/quiz/join', data: {
        'session_code': sessionCode,
      });

      if (response.statusCode == 200) {
        context.go('/session/$sessionCode'); // Navigate to quiz session
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
    return Scaffold(
      appBar: AppBar(title: const Text("Join a Quiz Session")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter Session Code",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _sessionCodeController,
              decoration: InputDecoration(
                labelText: "Session Code",
                border: OutlineInputBorder(),
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _joinSession,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Join Session"),
            ),
          ],
        ),
      ),
    );
  }
}
