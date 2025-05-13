import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/pages/questions/question-api.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SessionStudentPage extends StatefulWidget {
  final String code;

  const SessionStudentPage({super.key, required this.code});

  @override
  State<SessionStudentPage> createState() => _SessionStudentPageState();
}

class _SessionStudentPageState extends State<SessionStudentPage> {
  SessionMembership? _sessionMembership;
  Question? _activeQuestion;
  int _submittedAnswer = -1;

  final WebSocketChannel _webSocketChannel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'),
  );

  @override
  void initState() {
    super.initState();
    _webSocketChannel.stream.listen((message) async {
      var data = jsonDecode(message);
      print(data);
      if (data['type'] == 'newquestion') {
        var question = await QuestionApi.getActiveQuestion(widget.code);
        setState(() {
          _activeQuestion = question;
          _submittedAnswer = -1;
        });
      }
    });

    (() async {
      var membership = await QuestionApi.joinSession(widget.code);
      _webSocketChannel.sink.add(jsonEncode({
        'type': 'join',
        'session_code': int.parse(widget.code),
        'session_user_id': membership.sessionUserId
      }));
      setState(() {
        _sessionMembership = membership;
      });
    })();
  }

  void submitAnswer(int optionId) {
    if (_submittedAnswer != -1) {
      return; // Already submitted
    }
    QuestionApi.submitMultiChoiceAnswer(widget.code, _sessionMembership!.sessionUserId!, optionId);
    setState(() {
      _submittedAnswer = optionId;
    });
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
            Text(
              'Joined session: ${widget.code}',
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                // Match login page font style
                color: Colors
                    .black87, // Consistent with typical login color schemes
              ),
            ),
            SizedBox(height: 20),
            (() {
              if (_activeQuestion != null) {
                if (_activeQuestion?.questionType == QuestionType.multipleChoice) {
                  var questionData = _activeQuestion?.questionData as MultipleChoiceQuestionData;
                  return Column(
                    children: [
                      Text(
                        _activeQuestion!.question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          // Match login page font style
                          color: Colors
                              .black87, // Consistent with typical login color schemes
                        ),
                      ),
                      ...questionData.options.map((option) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: () {
                              submitAnswer(option.id!);
                            },
                            child: Ink(
                              width: 300,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _submittedAnswer == option.id
                                    ? Colors.blueAccent
                                    : Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: _submittedAnswer == option.id ? 3 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  option.text,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }
              }
              return const Text(
                'Waiting for question...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  // Match login page font style
                  color: Colors
                      .black87, // Consistent with typical login color schemes
                ),
              );
            })()
          ],
        )
      ),
    );
  }
}
