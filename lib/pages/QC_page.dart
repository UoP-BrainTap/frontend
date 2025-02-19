import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: QuestionFormPage(),
  ));
}

class QuestionFormPage extends StatefulWidget {
  @override
  _QuestionFormPageState createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends State<QuestionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text;
      final description = _descriptionController.text;
      final tags = _tagsController.text.split(',').map((tag) => tag.trim()).toList();

      print('Question Title: $title');
      print('Question Description: $description');
      print('Tags: $tags');

      _titleController.clear();
      _descriptionController.clear();
      _tagsController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Your question has been submitted!')),
      );
    }
  }

