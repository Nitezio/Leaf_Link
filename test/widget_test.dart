// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:plantcare_pro/main.dart';
import 'package:provider/provider.dart';
import 'package:plantcare_pro/models/app_state.dart';

void main() {
  testWidgets('Welcome to login to home flow', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const PlantCareApp(),
      ));

      expect(find.text('Get Started'), findsOneWidget);
      await tester.ensureVisible(find.text('Get Started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.pumpAndSettle();
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.text('Good Morning'), findsOneWidget);
    });
  });

  testWidgets('Bottom nav switches tabs', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(ChangeNotifierProvider(
        create: (_) => AppState(),
        child: const PlantCareApp(),
      ));
      await tester.ensureVisible(find.text('Get Started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
      await tester.ensureVisible(signInButton);
      await tester.pumpAndSettle();
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Community'));
      await tester.pumpAndSettle();
      expect(find.text('Posting as You'), findsOneWidget);

      await tester.tap(find.text('Market'));
      await tester.pumpAndSettle();
      expect(find.text('Marketplace'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Plant Parent'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.text('Good Morning'), findsOneWidget);
    });
  });
}
