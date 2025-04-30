import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/pages/questions/question-api.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionLecturerPage extends StatefulWidget {
  const SessionLecturerPage({super.key});

  @override
  State<SessionLecturerPage> createState() => _SessionLecturerPageState();
}

class _SessionLecturerPageState extends State<SessionLecturerPage> {
  int sessionCode = 0;
  int questionId = -1;
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    sessionCode = _generateSessionCode(); // Generate a random session code
    var shared = SharedPreferencesAsync();
    (() async {
      int? lecturerId = await shared.getInt('id');
      if (lecturerId == null) {
        return;
      }
      // Fetch questions from the API
      var questions = await QuestionApi.getUserQuestions(lecturerId);
      setState(() {
        _questions = questions;
      });
    })();
  }

  // Generate a random 6-digit session code
  int _generateSessionCode() {
    final random = Random();
    return 100000 + random.nextInt(900000); // Generates a 6-digit number
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Change to match login page color
        title: const Text(
          'Session',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600), // Match login/signup page fonts
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
              16.0), // Add padding to match login/signup style
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display session code and QR code
              Text(
                'Join Code: $sessionCode  Or scan QR with your phone',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold, // Match login page font style
                  color: Colors
                      .black87, // Consistent with typical login color schemes
                ),
              ),
              const SizedBox(height: 20),
              QrImageView(
                data:
                    'localhost:8080/session/$sessionCode', // Dynamically use session code
                version: QrVersions.auto,
                size: 150,
                gapless: false,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question selection section
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        const Text(
                          'Select Question',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent, // Match button color
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: _questions.map((question) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        question.question,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors
                                              .black87, // Match login text color
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.blueAccent, // Button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        "Send Question",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
