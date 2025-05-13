import 'package:flutter/material.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:frontend/pages/questions/question-api.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LecturerPage extends StatefulWidget {
  const LecturerPage({Key? key}) : super(key: key);

  @override
  State<LecturerPage> createState() => _LecturerPageState();
}

class _LecturerPageState extends State<LecturerPage> {
  List<Question> _questions = [];

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
        title: const Text('Lecturer Dashboard'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Lecturer Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                context.go('/lecturer/session');
              },
              child: const Text('Create Session', style: TextStyle(fontSize: 20))
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
                child: Column(
                  children: [
                    Text(
                      'Questions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/lecturer/question/create');
                      },
                      child: const Text('Create Question'),
                    ),
                    const SizedBox(height: 10),
                    (() {
                      if (_questions.isEmpty) {
                        return const Text('No questions available');
                      } else {
                        return Column(
                            children: _questions.map((question) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      question.question,
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      QuestionApi.deleteQuestion(question.id!);
                                      setState(() {
                                        _questions.remove(question);
                                      });
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList());
                      }
                    })(),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}