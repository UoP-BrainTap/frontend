import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/data/question-structs.dart';

class QuestionApi {
  static var dio = DioProvider().dio;

  static Future<List<Question>> getUserQuestions(int userId) async {
    var getQuestionsResponse = await dio.get('/api/v1/questions/user/$userId');
    if (getQuestionsResponse.statusCode == 200) {
      var data = jsonDecode(getQuestionsResponse.data);
      List<Question> questions = [];
      for (var questionData in data) {
        var question = Question.fromMap(questionData);
        fetchQuestionData(question);
        questions.add(question);
      }
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<Question<QuestionData>?> getQuestionById(String id) async {
    var getQuestionResponse = await dio.get('/api/v1/questions/$id');
    late Question question;
    if (getQuestionResponse.statusCode == 200) {
      question = Question.fromMap(getQuestionResponse.data);
    } else {
      throw Exception('Failed to load question');
    }
    fetchQuestionData(question);
    return question;
  }

  static Future<Question> fetchQuestionData(Question question) async {
    if (question.id == null) {
      throw Exception('Question ID is null');
    }
    if (question.questionType == QuestionType.multipleChoice) {
      var questionData = await getMultipleChoiceQuestionData(question.id.toString());
      question.questionData = questionData;
    }
    return question;
  }

  static Future<MultipleChoiceQuestionData> getMultipleChoiceQuestionData(String id) async {
    var getQuestionResponse = await dio.get('/api/v1/questions/multiple-choice/$id/options');
    if (getQuestionResponse.statusCode == 200) {
      var data = jsonDecode(getQuestionResponse.data);
      return MultipleChoiceQuestionData.fromMap(data);
    } else {
      throw Exception('Failed to load question');
    }
  }

  static Future<void> createMultipleChoiceQuestion(Question<MultipleChoiceQuestionData> question) async {
    var createQuestionResponse = await dio.post('/api/v1/questions/multiple-choice/', data: {
      'question-title': question.question,
      'options': question.questionData!.options.map((option) => {
        'option-text': option.text,
        'is-correct': option.isCorrect,
      }).toList(),
    }, options: Options(
      validateStatus: (status) {
        return status! < 500;
      },
    ));
    if (createQuestionResponse.statusCode != 200) {
      print(createQuestionResponse);
      throw Exception('Failed to create question');
    }
  }

  static Future<void> deleteQuestion(int id) async {
    var deleteQuestionResponse = await dio.delete('/api/v1/questions/$id');
    if (deleteQuestionResponse.statusCode != 200) {
      throw Exception('Failed to delete question');
    }
  }
}