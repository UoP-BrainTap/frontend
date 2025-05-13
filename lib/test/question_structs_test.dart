import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/questions/question-structs.dart';

void main() {
  group('QuestionType', () {
    test('fromString correctly parses valid types', () {
      expect(QuestionType.fromString("multiple_choice"), QuestionType.multipleChoice);
      expect(QuestionType.fromString("short_text"), QuestionType.shortText);
    });

    test('fromString throws an exception for invalid type', () {
      expect(() => QuestionType.fromString("unknown_type"), throwsA(isA<Exception>()));
    });
  });

  group('Question', () {
    test('fromMap correctly parses data into Question object', () {
      final data = {
        'id': 1,
        'owner_id': 2,
        'question': 'What is Flutter?',
        'question_type': 'multiple_choice',
      };

      final question = Question<QuestionData>.fromMap(data);

      expect(question.id, 1);
      expect(question.ownerId, 2);
      expect(question.question, 'What is Flutter?');
      expect(question.questionType, QuestionType.multipleChoice);
    });

    test('fromMap throws exception for invalid question type', () {
      final data = {
        'id': 1,
        'owner_id': 2,
        'question': 'What is Flutter?',
        'question_type': 'unknown_type',
      };

      expect(() => Question<QuestionData>.fromMap(data), throwsA(isA<Exception>()));
    });
  });

  group('MultipleChoiceQuestionData', () {
    test('fromMap correctly parses data into MultipleChoiceQuestionData', () {
      final data = [
        {'option_text': 'Option 1', 'is_correct': true},
        {'option_text': 'Option 2', 'is_correct': false},
      ];

      final multipleChoiceQuestionData = MultipleChoiceQuestionData.fromMap(data);

      expect(multipleChoiceQuestionData.options.length, 2);
      expect(multipleChoiceQuestionData.options[0].text, 'Option 1');
      expect(multipleChoiceQuestionData.options[0].isCorrect, true);
      expect(multipleChoiceQuestionData.options[1].text, 'Option 2');
      expect(multipleChoiceQuestionData.options[1].isCorrect, false);
    });

    test('fromMap handles empty data', () {
      final data = [];

      final multipleChoiceQuestionData = MultipleChoiceQuestionData.fromMap(data);

      expect(multipleChoiceQuestionData.options.isEmpty, true);
    });
  });
}
