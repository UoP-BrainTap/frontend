import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/main.dart';

class QuestionCreationPage extends StatefulWidget {
  const QuestionCreationPage({super.key});

  @override
  _QuestionCreationPageState createState() => _QuestionCreationPageState();
}

class _QuestionCreationPageState extends State<QuestionCreationPage> {
  final _formKey = GlobalKey<FormState>();
  String _questionType = 'Multiple Choice';
  final TextEditingController _questionTitleController = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _option4Controller = TextEditingController();
  final TextEditingController _correctAnswerController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_questionType == 'Multiple Choice') {
        String questionTitle = _questionTitleController.text;
        String option1 = _option1Controller.text;
        String option2 = _option2Controller.text;
        String option3 = _option3Controller.text;
        String option4 = _option4Controller.text;

        // Process the data (e.g., send it to a server or save it locally)
        print('Multiple Choice Question: $questionTitle');
        print('Option 1: $option1');
        print('Option 2: $option2');
        print('Option 3: $option3');
        print('Option 4: $option4');
      } else if (_questionType == 'True or False') {
        String questionTitle = _questionTitleController.text;
        String correctAnswer = _correctAnswerController.text;

        // Process the data (e.g., send it to a server or save it locally)
        print('True or False Question: $questionTitle');
        print('Correct Answer: $correctAnswer');
      } else if (_questionType == 'Drag and Drop') {
        String questionTitle = _questionTitleController.text;

        // Process the data (e.g., send it to a server or save it locally)
        print('Drag and Drop Question: $questionTitle');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Row(
          children: [
            const SizedBox(width: 40),
            Image.asset(
              'assets/images/web_icon.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text(
              'BrainTap',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black, fontSize: 32),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          const SizedBox(width: 20),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              context.go('/home'); // Navigates to the Home page
            },
          ),
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              context.go('/login'); // Navigates to the Login page
            },
          ),
          const SizedBox(width: 50),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20), // Adjusted padding
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _questionType,
                items: <String>['Multiple Choice', 'True or False', 'Drag and Drop']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _questionType = newValue!;
                  });
                },
                dropdownColor: Colors.deepPurple.shade100,
                style: TextStyle(color: Colors.deepPurple.shade900),
                iconEnabledColor: Colors.deepPurple.shade900, // Darker expand arrow
              ),
              const SizedBox(height: 20),
              Flexible(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Question Creation Page',
                        style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                      ),
                      const SizedBox(height: 20),
                      if (_questionType == 'Multiple Choice') _buildMultipleChoiceForm(),
                      if (_questionType == 'True or False') _buildTrueOrFalseForm(),
                      if (_questionType == 'Drag and Drop') _buildDragAndDropForm(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMultipleChoiceForm() {
    return Column(
      children: [
        TextFormField(
          controller: _questionTitleController,
          decoration: const InputDecoration(
            labelText: 'Question',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option1Controller,
          decoration: const InputDecoration(
            labelText: 'Option 1',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option2Controller,
          decoration: const InputDecoration(
            labelText: 'Option 2',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option3Controller,
          decoration: const InputDecoration(
            labelText: 'Option 3 (optional)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option4Controller,
          decoration: const InputDecoration(
            labelText: 'Option 4 (optional)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildTrueOrFalseForm() {
    return Column(
      children: [
        TextFormField(
          controller: _questionTitleController,
          decoration: const InputDecoration(
            labelText: 'Question',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _correctAnswerController,
          decoration: const InputDecoration(
            labelText: 'Correct Answer (True/False)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildDragAndDropForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        TextFormField(
          controller: _questionTitleController,
          decoration: const InputDecoration(
            labelText: 'Question (use "_" for empty spots)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            if (!value.contains('_')) {
              return 'The question must contain at least one "_"';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option1Controller,
          decoration: const InputDecoration(
            labelText: 'Answer 1',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option2Controller,
          decoration: const InputDecoration(
            labelText: 'Answer 2',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.greenAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill the box';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option3Controller,
          decoration: const InputDecoration(
            labelText: 'Answer 3 (optional)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _option4Controller,
          decoration: const InputDecoration(
            labelText: 'Answer 4 (optional)',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white, // Set text box background color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          ),
          style: TextStyle(color: Colors.grey.shade800), // Darker text color
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

class DragAndDropQuestion extends StatefulWidget {
  final String question;
  final List<String> answers;
  final bool showDragBoxes;

  const DragAndDropQuestion({
    required this.question,
    required this.answers,
    this.showDragBoxes = false,
  });

  @override
  _DragAndDropQuestionState createState() => _DragAndDropQuestionState();
}

class _DragAndDropQuestionState extends State<DragAndDropQuestion> {
  List<String?> droppedAnswers = [];

  @override
  void initState() {
    super.initState();
    droppedAnswers = List<String?>.filled(widget.answers.length, null);
  }

  @override
  Widget build(BuildContext context) {
    List<String> questionParts = widget.question.split('_');

    return Column(
      children: [
        Wrap(
          children: List.generate(questionParts.length, (index) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(questionParts[index]),
                if (index < questionParts.length - 1)
                  DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 100,
                        height: 50,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Text(droppedAnswers[index] ?? 'Drop here'),
                        ),
                      );
                    },
                    onAccept: (data) {
                      setState(() {
                        droppedAnswers[index] = data;
                      });
                    },
                  ),
              ],
            );
          }),
        ),
        const SizedBox(height: 20),
        if (widget.showDragBoxes)
          Wrap(
            spacing: 10,
            children: widget.answers.map((answer) {
              return Draggable<String>(
                data: answer,
                child: Chip(label: Text(answer)),
                feedback: Material(
                  child: Chip(label: Text(answer)),
                ),
                childWhenDragging: Chip(
                  label: Text(answer),
                  backgroundColor: Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}