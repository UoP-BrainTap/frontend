import 'package:flutter/material.dart';

class FAQpage extends StatelessWidget {
  final List<FAQ> faqlist = [
    FAQ(question: "A", answer: "B"),
    FAQ(question: "C", answer: "D"),
    FAQ(question: "E", answer: "F"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FAQ")),
      body: ListView.builder(
        itemCount: faqlist.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqlist[index].question),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faqlist[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;
  FAQ({required this.question, required this.answer});
}

