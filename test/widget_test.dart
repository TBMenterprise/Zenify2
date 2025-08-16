// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mainproject/MainPages/main.dart';

void main() {
  testWidgets('StartPage shows title and buttons', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the main title is displayed.
    expect(find.text('ZeniFY'), findsOneWidget);

    // Verify that the Sign up button is displayed.
    expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);

    // Verify that the Login button is displayed.
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });
}
