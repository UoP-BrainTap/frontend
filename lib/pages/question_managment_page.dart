import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuestionManagementPage extends StatefulWidget {
  const QuestionManagementPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuestionManagementPageState();
  }
}

class _QuestionManagementPageState extends State<QuestionManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Questions'),
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text('Questions will be displayed here'),
            SizedBox(height: 50),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
                MultipleChoiceQuestionEntry(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MultipleChoiceQuestionEntry extends StatelessWidget {
  const MultipleChoiceQuestionEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: InkWell(
        onTap: () {
          context.go('/question/manage/1');
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Column(
                children: [
                  Text("Question Example 1", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Answers: 4"),
                  Text("Sessions: 2"),
                  Text("Created On: 2021-10-01"),
                ],
              ),
              Column(
                children: [
                  Text("Manage")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}