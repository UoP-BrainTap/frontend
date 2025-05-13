import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/button.dart';

void main() {
  group('ButtonWidget', () {
    testWidgets('renders an outlined button with correct properties',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              text: 'Outlined Button',
              onPressed: () {
                pressed = true;
              },
              isOutlined: true,
              color: Colors.red,
              textSize: 18,
            ),
          ),
        ),
      );

      expect(find.text('Outlined Button'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);

      final outlinedButton =
          tester.widget<OutlinedButton>(find.byType(OutlinedButton));
      final borderSide =
          outlinedButton.style?.side?.resolve({WidgetState.pressed}) ??
              outlinedButton.style?.side?.resolve({});

      expect(borderSide?.color, Colors.red);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
      expect(pressed, true);
    });

    testWidgets('renders a filled button with correct properties',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              text: 'Filled Button',
              onPressed: () {
                pressed = true;
              },
              color: Colors.blue,
              textColor: Colors.yellow,
              textSize: 20,
              borderRadius: 30,
            ),
          ),
        ),
      );

      expect(find.text('Filled Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      final elevatedButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final backgroundColor =
          elevatedButton.style?.backgroundColor?.resolve({}) ??
              Colors.transparent;
      expect(backgroundColor, Colors.blue);

      final text = tester.widget<Text>(find.text('Filled Button'));
      expect(text.style?.color, Colors.yellow);
      expect(text.style?.fontSize, 20);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(pressed, true);
    });

    testWidgets('renders with default properties when not specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ButtonWidget(
              text: 'Default Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Default Button'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      final elevatedButton =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final backgroundColor =
          elevatedButton.style?.backgroundColor?.resolve({}) ??
              Colors.transparent;
      expect(backgroundColor, Colors.purple);
    });
  });
}
