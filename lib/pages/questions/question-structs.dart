/// The different types of questions
enum QuestionType {
  multipleChoice("Multiple Choice"),
  shortText("Short Text");

  final String name;

  const QuestionType(this.name);

  /// Converts a [String] to a [QuestionType]
  static QuestionType fromString(String type) {
    switch (type) {
      case "multiple_choice":
        return QuestionType.multipleChoice;
      case "short_text":
        return QuestionType.shortText;
      default:
        throw Exception("Unknown question type: $type");
    }
  }
}

/// Podo representing a base question
///
/// [id] The ID of the question
/// [ownerId] The ID of the owner
/// [question] The question text
/// [questionType] The type of the question
/// [questionData] The data associated with the question, potentially null and
/// must be fetched
class Question<T extends QuestionData> {
  final int? id;
  final int? ownerId;
  final String question;
  final QuestionType questionType;
  T? questionData;

  Question({
    this.id,
    this.ownerId,
    required this.question,
    required this.questionType,
    this.questionData,
  });

  /// Deserializes [data] into a [Question] object
  static Question<QuestionData> fromMap(Map data) {
    return Question(
        id: data['id'],
        ownerId: data['owner_id'],
        question: data['question'],
        questionType: QuestionType.fromString(data['question_type']));
  }
}

/// Represents the data associated with a question
abstract class QuestionData {}

/// Represents a multiple choice [QuestionData]
///
/// [options] The list of options for the question
class MultipleChoiceQuestionData extends QuestionData {
  final List<MultipleChoiceOptionData> options;

  MultipleChoiceQuestionData({required this.options});

  /// Deserializes [data] into a [MultipleChoiceQuestionData] object
  static MultipleChoiceQuestionData fromMap(List data) {
    var multipleChoiceOptions = data
        .map((option) => MultipleChoiceOptionData(
            text: option['option_text'], isCorrect: option['is_correct']))
        .toList();
    return MultipleChoiceQuestionData(options: multipleChoiceOptions);
  }
}

/// Represents an option for a [MultipleChoiceQuestionData]
///
/// [id] The ID of the option
/// [text] The text of the option
/// [isCorrect] Whether the option is correct or not
class MultipleChoiceOptionData {
  final int? id;
  final String text;
  final bool isCorrect;

  MultipleChoiceOptionData({this.id, required this.text, required this.isCorrect});
}

/// Podo representing a session
///
/// [sessionId] The ID of the session
/// [sessionCode] The code of the session
class Session {
  final int sessionId;
  final int sessionCode;

  Session(this.sessionId, this.sessionCode);
}

/// Podo representing a session membership
///
/// [sessionUserId] The ID of the user in the session
/// [anonymousId] The anonymous ID of the user in the session
class SessionMembership {
  int? sessionUserId;
  String? anonymousId;

  SessionMembership(this.sessionUserId, this.anonymousId);
}
