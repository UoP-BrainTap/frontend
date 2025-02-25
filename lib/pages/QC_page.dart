import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuestionFormPage(),
  ));
}

class QuestionFormPage extends StatefulWidget {
  @override
  QuestionFormPageState createState() => QuestionFormPageState();
}

class QuestionFormPageState extends State<QuestionFormPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final tagsController = TextEditingController();

  void submitForm() {
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final description = descriptionController.text;
      final tags = tagsController.text.split(',').map((tag) => tag.trim()).toList();

      print('Question Title: $title');
      print('Question Description: $description');
      print('Tags: $tags');

      titleController.clear();
      descriptionController.clear();
      tagsController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your question has been submitted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask a Question'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Post Your Question',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe your question';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: tagsController,
                  decoration: InputDecoration(
                    labelText: 'Tags (comma-separated)',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16),
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
}
