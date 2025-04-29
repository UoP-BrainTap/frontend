import 'package:flutter/material.dart';
import 'package:frontend/pages/questions/question-api.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionLecturerPage extends StatefulWidget {
  const SessionLecturerPage({Key? key}) : super(key: key);

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
    sessionCode = 555555;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Join Code: 555555  Or scan QR with your phone',
              style: TextStyle(fontSize: 30),
            ),
            QrImageView(
              data: 'localhost:8080/session/555555',
              version: QrVersions.auto,
              size: 150,
              gapless: false,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      const Text(
                        'Select Question',
                        style: TextStyle(fontSize: 30),
                      ),
                      Column(
                        children: _questions.map((question) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      question.question,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  ElevatedButton(onPressed: () {}, child: Text("Send Question"))
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: const Column(
                    children: [
                      Text(
                        'Connected Users',
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 20),
                      Text("User 1"),
                      SizedBox(height: 20),
                      Text("User 2"),
                      SizedBox(height: 20),
                      Text("User 3"),
                      SizedBox(height: 20),
                      Text("User 4"),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}