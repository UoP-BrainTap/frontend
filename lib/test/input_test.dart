import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/widgets/input.dart';

void main() {
  group('CustomInputField', () {
    testWidgets('displays the label text', (WidgetTester tester) async {
      final controller = TextEditingController();
      const label = 'Email';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInputField(
              label: label,
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text(label), findsOneWidget);
    });

    testWidgets('displays TextField with correct properties', (WidgetTester tester) async {
      final controller = TextEditingController();
      const label = 'Password';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInputField(
              label: label,
              controller: controller,
              isPassword: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, true);
    });

    testWidgets('shows visibility icon for password field', (WidgetTester tester) async {
      final controller = TextEditingController();
      const label = 'Password';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInputField(
              label: label,
              controller: controller,
              isPassword: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('does not show visibility icon for non-password field', (WidgetTester tester) async {
      final controller = TextEditingController();
      const label = 'Username';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomInputField(
              label: label,
              controller: controller,
              isPassword: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.visibility), findsNothing);
    });
  });
}
