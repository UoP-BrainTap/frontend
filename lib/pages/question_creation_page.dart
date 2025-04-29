import 'package:flutter/material.dart';
import 'package:frontend/pages/questions/question-api.dart';
import 'package:frontend/pages/questions/question-structs.dart';
import 'package:frontend/widgets/button.dart';
import 'package:go_router/go_router.dart';

class QuestionCreationPage extends StatefulWidget {
  const QuestionCreationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _QuestionCreationPageState();
  }
}

class _QuestionCreationPageState extends State<QuestionCreationPage> {
  QuestionType _questionType = QuestionType.multipleChoice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Question'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QuestionTypeSelector(
                  type: QuestionType.multipleChoice,
                  active: _questionType == QuestionType.multipleChoice,
                  onPressed: () {
                    setState(() {
                      _questionType = QuestionType.multipleChoice;
                    });
                  },
                ),
                QuestionTypeSelector(
                  type: QuestionType.shortText,
                  active: _questionType == QuestionType.shortText,
                  onPressed: () {
                    setState(() {
                      _questionType = QuestionType.shortText;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
            (() {
              if (_questionType == QuestionType.multipleChoice) {
                return const MultipleChoiceQuestionCreation();
              } else {
                return const Text('Short Text Question');
              }
            })()
          ],
        ),
      ),
    );
  }
}

class QuestionTypeSelector extends StatelessWidget {
  final QuestionType type;
  final bool active;
  final VoidCallback onPressed;

  const QuestionTypeSelector(
      {super.key,
      required this.type,
      required this.onPressed,
      required this.active});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: active ? Colors.grey[400] : Colors.white,
        ),
        child: MaterialButton(
          onPressed: onPressed,
          child: SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Text(type.name, textAlign: TextAlign.center),
            ),
          ),
        ),
      ),
    );
  }
}

class MultipleChoiceQuestionCreation extends StatefulWidget {
  const MultipleChoiceQuestionCreation({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MultipleChoiceQuestionCreation();
  }
}

class _MultipleChoiceQuestionCreation
    extends State<MultipleChoiceQuestionCreation> {
  final _formKey = GlobalKey<FormState>();

  // UI data
  final _options = <MultipleChoiceOption>[];
  bool _isSnackBarActive = false;

  // Form data
  String? _questionTitle;

  _optionAdded() {
    if (_options.length >= 6) {
      if (!_isSnackBarActive) {
        // notify user that they can't add more options
        _isSnackBarActive = true;
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text('You can only add 6 options'),
                duration: Duration(seconds: 2),
              ),
            )
            .closed
            .then((_) {
          _isSnackBarActive = false;
        });
      }
      return;
    }
    setState(() {
      var key = GlobalKey<_MultipleChoiceOptionWidgetState>();
      var widget = MultipleChoiceOptionWidget(
          key: key,
          canDelete: true,
          onDelete: _optionDeleted,
        );
      _options.add(MultipleChoiceOption(key, widget));
    });
  }

  _optionDeleted(MultipleChoiceOptionWidget option) {
    setState(() {
      _options.remove(option);
    });
  }

  _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    MultipleChoiceQuestionData questionData = MultipleChoiceQuestionData(options: _options.map((option) {
      return MultipleChoiceOptionData(
        text: option.state.currentState!.optionTitle!,
        isCorrect: option.state.currentState!.isCorrect ?? false,
      );
    }).toList());
    Question<MultipleChoiceQuestionData> question = Question<MultipleChoiceQuestionData>(
      question: _questionTitle!,
      questionType: QuestionType.multipleChoice,
      questionData: questionData
    );
    QuestionApi.createMultipleChoiceQuestion(question);
    context.go('/lecturer');
  }

  @override
  void initState() {
    super.initState();
    var key1 = GlobalKey<_MultipleChoiceOptionWidgetState>();
    var widget1 = MultipleChoiceOptionWidget(
      key: key1,
      canDelete: false,
      onDelete: null,
    );
    _options.add(MultipleChoiceOption(key1, widget1));
    var key2 = GlobalKey<_MultipleChoiceOptionWidgetState>();
    var widget2 = MultipleChoiceOptionWidget(
      key: key2,
      canDelete: false,
      onDelete: null,
    );
    _options.add(MultipleChoiceOption(key2, widget2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Question',
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  return value != null && value.isNotEmpty
                      ? null
                      : 'Please enter a question title';
                },
                onSaved: (value) {
                  _questionTitle = value;
                },
              ),
              ..._options.map((option) {
                return option.widget;
              }),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MaterialButton(
                  onPressed: () {
                    _optionAdded();
                  },
                  child: const Text('Add Option'),
                )
              ),
              const SizedBox(height: 10),
              ButtonWidget(text: "Create Question", onPressed: _submit)
            ],
          ),
        )
      )
    );
  }
}

class MultipleChoiceOption {
  GlobalKey<_MultipleChoiceOptionWidgetState> state;
  MultipleChoiceOptionWidget widget;

  MultipleChoiceOption(this.state, this.widget);
}

class MultipleChoiceOptionWidget extends StatefulWidget {
  final bool canDelete;
  final Function? onDelete;

  const MultipleChoiceOptionWidget(
      {super.key, required this.canDelete, required this.onDelete});

  @override
  State<StatefulWidget> createState() {
    return _MultipleChoiceOptionWidgetState();
  }
}

class _MultipleChoiceOptionWidgetState
    extends State<MultipleChoiceOptionWidget> {

  // Form Data
  String? _optionTitle = "";
  bool? _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Option',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return value != null && value.isNotEmpty
                    ? null
                    : 'Please enter an option';
              },
              onSaved: (value) {
                _optionTitle = value!;
              },
            ),
          ),
          FormField(builder: (state) {
            return Checkbox(
              value: state.value != null ? state.value as bool : false,
              onChanged: (value) {
                state.didChange(value);
              },
              activeColor: Colors.green, // Set the active color to green
            );
          }, onSaved: (value) {
            _isCorrect = value as bool?;
          }),
          InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: () {
                widget.onDelete?.call(this);
              },
              child: Ink(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.canDelete ? Colors.red : Colors.grey,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: const Center(
                  child: Text("X"),
                ),
              ))
        ],
      ),
    );
  }

  bool? get isCorrect => _isCorrect;

  String? get optionTitle => _optionTitle;
}