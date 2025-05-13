import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/pages/questions/question-api.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SessionLecturerPage extends StatefulWidget {
  const SessionLecturerPage({super.key});

  @override
  State<SessionLecturerPage> createState() => _SessionLecturerPageState();
}

class _SessionLecturerPageState extends State<SessionLecturerPage> {
  Session? _session;
  List<Question> _questions = [];
  int _activeQuestion = -1;
  Map<int, int> _votes = {};

  final WebSocketChannel _webSocketChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'),
  );

  @override
  void initState() {
    super.initState();
    var shared = SharedPreferencesAsync();
    (() async {
      int? lecturerId = await shared.getInt('id');
      if (lecturerId == null) {
        return;
      }
      // Fetch questions from the API
      QuestionApi.getUserQuestions(lecturerId).then((questions) {
        setState(() {
          _questions = questions;
        });
      });

      QuestionApi.newSession().then((session) {
        _webSocketChannel.sink.add(jsonEncode({
          'type': 'lect_join',
          'session_code': session.sessionCode,
        }));
        setState(() {
          _session = session;
        });
      });
    })();
    _webSocketChannel.stream.listen((message) async {
      var data = jsonDecode(message);
      if (data['type'] == 'newanswer') {
        setState(() {
          var optionId = data['option_id'];
          if (_votes.containsKey(optionId)) {
            _votes[optionId] = _votes[optionId]! + 1;
          } else {
            _votes[optionId] = 1;
          }
        });
      }
    });
  }

  void setNewQuestion(int questionId) {
    QuestionApi.setActiveQuestion(_session!.sessionCode.toString(), questionId);
    setState(() {
      _activeQuestion = questionId;
      _votes.clear();
    });
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
          // Add padding to match login/signup style
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...(() {
                if (_session == null) {
                  return [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    const Text(
                      'Loading session...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87, // Match login text color
                      ),
                    ),
                  ];
                }
                return [
                  // Display session code and QR code
                  Text(
                    'Join Code: ${_session?.sessionCode}  Or scan QR with your phone',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      // Match login page font style
                      color: Colors
                          .black87, // Consistent with typical login color schemes
                    ),
                  ),
                  const SizedBox(height: 20),
                  QrImageView(
                    data: 'localhost:8080/session/${_session?.sessionCode}',
                    // Dynamically use session code
                    version: QrVersions.auto,
                    size: 150,
                    gapless: false,
                  ),
                ];
              })(),
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
                        ...(() {
                          if (_activeQuestion != -1) {
                            Question activeQuestion = _questions
                                .firstWhere((q) => q.id == _activeQuestion);
                            return [
                              const Text(
                                'Active Question',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent, // Match button color
                                ),
                              ),
                              Text(activeQuestion.question,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ...(() {
                                var list = [];
                                for (var option in (activeQuestion.questionData as MultipleChoiceQuestionData).options) {
                                  list.add(SizedBox(
                                    height: 50,
                                    width: 300,
                                    child: Container(
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                option.text,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Text("Votes: ${_votes[option.id] ?? 0}",
                                            style: TextStyle(
                                              fontSize: 18
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ));
                                  list.add(const SizedBox(height: 10));
                                }
                                return list;
                              })()
                            ];
                          } else {
                            return [];
                          }
                        })(),
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
                                      onPressed: () {
                                        if (question.id != null) {
                                          setNewQuestion(question.id!);
                                        }
                                      },
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
