import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:frontend/pages/questions/question-api.dart';

abstract class MockDio extends Dio {
  final Map<String, dynamic> responses = {};

  void addMockResponse(String path, dynamic response, {int statusCode = 200}) {
    responses[path] = {'data': response, 'statusCode': statusCode};
  }

  @override
  Future<Response<T>> get<T>(String path, {Options? options}) async {
    if (responses.containsKey(path)) {
      return Response<T>(
        data: responses[path]['data'] as T,
        statusCode: responses[path]['statusCode'] as int,
        requestOptions: RequestOptions(path: path),
      );
    }
    return Response<T>(
      statusCode: 404,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<T>> delete<T>(String path, {Options? options}) async {
    if (responses.containsKey(path)) {
      return Response<T>(
        statusCode: responses[path]['statusCode'] as int,
        requestOptions: RequestOptions(path: path),
      );
    }
    return Response<T>(
      statusCode: 404,
      requestOptions: RequestOptions(path: path),
    );
  }

  @override
  Future<Response<T>> post<T>(String path,
      {dynamic data, Options? options}) async {
    if (responses.containsKey(path)) {
      return Response<T>(
        statusCode: responses[path]['statusCode'] as int,
        requestOptions: RequestOptions(path: path),
      );
    }
    return Response<T>(
      statusCode: 404,
      requestOptions: RequestOptions(path: path),
    );
  }
}

void main() {
  group('QuestionApi Tests', () {
    late MockDio mockDio;

    setUp(() {
      mockDio = MockDio();
      QuestionApi.dio = mockDio;
    });

    test('getUserQuestions returns a list of questions', () async {
      const userId = 1;
      final mockResponseData = [
        {'id': 1, 'question': 'What is Flutter?', 'questionType': 'text'},
        {
          'id': 2,
          'question': 'Explain State Management',
          'questionType': 'text'
        },
      ];

      mockDio.addMockResponse(
          '/api/v1/questions/user/$userId', mockResponseData);

      final questions = await QuestionApi.getUserQuestions(userId);

      expect(questions, isA<List<Question>>());
      expect(questions.length, 2);
      expect(questions[0].question, 'What is Flutter?');
      expect(questions[1].question, 'Explain State Management');
    });

    test('deleteQuestion sends a delete request', () async {
      const questionId = 1;

      mockDio.addMockResponse('/api/v1/questions/$questionId', null,
          statusCode: 200);

      await QuestionApi.deleteQuestion(questionId);

      final response = await mockDio.delete('/api/v1/questions/$questionId');
      expect(response.statusCode, 200);
    });

    test('createMultipleChoiceQuestion sends a post request', () async {
      final question = Question<MultipleChoiceQuestionData>(
        id: null,
        question: 'Sample Multiple Choice Question',
        questionData: MultipleChoiceQuestionData(
          options: [
            MultipleChoiceOptionData(text: 'Option 1', isCorrect: true),
            MultipleChoiceOptionData(text: 'Option 2', isCorrect: false),
          ],
        ),
      );

      mockDio.addMockResponse('/api/v1/questions/multiple-choice/', null,
          statusCode: 200);

      await QuestionApi.createMultipleChoiceQuestion(question);

      final response = await mockDio.post('/api/v1/questions/multiple-choice/');
      expect(response.statusCode, 200);
    });
  });
}
