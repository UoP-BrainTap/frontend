import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/session_lecturer_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionLecturerPage', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({'id': 1});
    });

    testWidgets('displays the join code and QR code',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SessionLecturerPage(),
        ),
      );

      expect(find.text('Join Code: 555555  Or scan QR with your phone'),
          findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
    });

    testWidgets('displays the question selection area',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SessionLecturerPage(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Select Question'), findsOneWidget);
    });

    testWidgets('displays connected users section',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SessionLecturerPage(),
        ),
      );

      expect(find.text('Connected Users'), findsOneWidget);
    });
  });
}
