import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/main.dart';
import 'package:frontend/pages/questions/question-structs.dart';

/// API wrapper for managing questions and sessions
class QuestionApi {
  static var dio = DioProvider().dio;

  /// Fetches all questions for a given [userId]
  static Future<List<Question>> getUserQuestions(int userId) async {
    var getQuestionsResponse = await dio.get('/api/v1/questions/user/$userId');
    if (getQuestionsResponse.statusCode == 200) {
      var data = jsonDecode(getQuestionsResponse.data);
      List<Question> questions = [];
      for (var questionData in data) {
        var question = Question.fromMap(questionData);
        questions.add(await fetchQuestionData(question));
      }
      return questions;
    } else {
      throw Exception('Failed to load questions');
    }
  }

  /// Fetches a [Question] by its [id]
  static Future<Question<QuestionData>?> getQuestionById(String id) async {
    var getQuestionResponse = await dio.get('/api/v1/questions/$id');
    late Question question;
    if (getQuestionResponse.statusCode == 200) {
      question = Question.fromMap(jsonDecode(getQuestionResponse.data));
    } else {
      throw Exception('Failed to load question');
    }
    return await fetchQuestionData(question);
  }

  /// Fetches the question data for a given [question] and attaches it to the
  /// question object.
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

  /// Fetches the [MultipleChoiceQuestionData] for a given [id]
  static Future<MultipleChoiceQuestionData> getMultipleChoiceQuestionData(String id) async {
    var getQuestionResponse = await dio.get('/api/v1/questions/multiple-choice/$id/options');
    if (getQuestionResponse.statusCode == 200) {
      var data = jsonDecode(getQuestionResponse.data);
      return MultipleChoiceQuestionData.fromMap(data);
    } else {
      throw Exception('Failed to load question');
    }
  }

  /// Creates a new multiple choice question from the podo [question]
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

  /// Deletes a question by its [id]
  static Future<void> deleteQuestion(int id) async {
    var deleteQuestionResponse = await dio.delete('/api/v1/questions/$id');
    if (deleteQuestionResponse.statusCode != 200) {
      throw Exception('Failed to delete question');
    }
  }

  /// Creates a new session and returns the podo [Session]
  static Future<Session> newSession() async {
    var newSessionResponse = await dio.post('/api/v1/sessions/new');
    if (newSessionResponse.statusCode == 200) {
      var data = jsonDecode(newSessionResponse.data);
      return Session(data["session_id"], data["session_code"]);
    } else {
      throw Exception('Failed to create session');
    }
  }

  /// Joins an existing session with the given [sessionCode] and returns the
  static Future<SessionMembership> joinSession(String sessionCode) async {
    var joinSessionResponse = await dio.post('/api/v1/sessions/join/$sessionCode');
    if (joinSessionResponse.statusCode == 200) {
      var data = jsonDecode(joinSessionResponse.data);
      return SessionMembership(data['session_user_id'], data['anonymous_id']);
    } else {
      throw Exception('Failed to join session');
    }
  }

  /// Fetches the active [Question] for a given [sessionCode]. Return is null if
  /// no active question is found.
  static Future<Question?> getActiveQuestion(String sessionCode) async {
    var getActiveQuestionResponse = await dio.get('/api/v1/sessions/$sessionCode/question');
    if (getActiveQuestionResponse.statusCode == 200) {
      var data = jsonDecode(getActiveQuestionResponse.data);
      return getQuestionById(data['question_id'].toString());
    } else {
      return null;
    }
  }

  /// Sets the active [questionId] for a given [sessionCode]
  static Future<void> setActiveQuestion(String sessionCode, int questionId) async {
    var setActiveQuestionResponse = await dio.post('/api/v1/sessions/$sessionCode/question', data: {
      'question_id': questionId,
    });
    if (setActiveQuestionResponse.statusCode != 200) {
      throw Exception('Failed to set active question');
    }
  }

  /// Submits a multiple choice answer for a given [sessionCode],
  /// [sessionUserId], and [optionId]
  static Future<void> submitMultiChoiceAnswer(String sessionCode, int sessionUserId, int optionId) async {
    var submitAnswerResponse = await dio.post('/api/v1/sessions/$sessionCode/question/answer', data: {
      'session_user_id': sessionUserId,
      'selected_options': [optionId],
    });
    if (submitAnswerResponse.statusCode != 200) {
      throw Exception('Failed to submit answer');
    }
  }
}