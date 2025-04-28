import 'package:flutter/material.dart';
import 'package:frontend/widgets/button.dart';
import 'package:password_strength_checker/password_strength_checker.dart';

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

enum QuestionType {
  multipleChoice("Multiple Choice"),
  shortText("Short Text");

  final String name;

  const QuestionType(this.name);
}

class QuestionTypeSelector extends StatelessWidget {
  final QuestionType type;
  final bool active;
  final VoidCallback onPressed;

  const QuestionTypeSelector({super.key, required this.type, required this.onPressed, required this.active});

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

class _MultipleChoiceQuestionCreation extends State<MultipleChoiceQuestionCreation> {
  final _formKey = GlobalKey<FormState>();

  final _options = <MultipleChoiceOption>[];

  _optionAdded() {
    if (_options.length >= 5) {
      return;
    }
    setState(() {
      _options.add(MultipleChoiceOption(canDelete: true, onDelete: _optionDeleted));
    });
  }

  _optionDeleted(MultipleChoiceOption option) {
    setState(() {
      _options.remove(option);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Question',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return value != null && value.isNotEmpty ? null : 'Please enter a question title';
              },
            ),
            const MultipleChoiceOption(canDelete: false, onDelete: null),
            const MultipleChoiceOption(canDelete: false, onDelete: null),
            ..._options,
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: MaterialButton(onPressed: () {
                _optionAdded();
              }, child: const Text('Add Option'),)
            ),
          ],
        ),
      ))
    );
  }
}

class MultipleChoiceOption extends StatelessWidget {
  final bool canDelete;
  final Function? onDelete;

  const MultipleChoiceOption({super.key, required this.canDelete, required this.onDelete});

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
            ),
          ),

          FormField(builder: (state) {
            return Checkbox(
              value: state.value != null ? state.value as bool : false,
              onChanged: (value) {
                state.didChange(value);
              },
            );
          }),
          InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () {
              onDelete?.call(this);
            },
            child: Ink(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: canDelete ? Colors.red : Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: const Center(
                child: Text("X"),
              ),
            )
          )
        ],
      ),
    );
  }
}