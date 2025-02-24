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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Question'),
        backgroundColor: Colors.deepPurple,
        actions: [
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
        ],
      ),
      body: Container(
        color: Colors.blue, // Set background color to blue
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: _questionType,
                  items: <String>['Multiple Choice', 'True or False']
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
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Question Creation Page',
                          style: TextStyle(fontSize: 24, color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 20),
                        if (_questionType == 'Multiple Choice') _buildMultipleChoiceForm(),
                        if (_questionType == 'True or False') _buildTrueOrFalseForm(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
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
        ),
        const SizedBox(height: 20),
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
        ),
        const SizedBox(height: 20),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
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