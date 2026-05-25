import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:plantcare_pro/main.dart';
import 'package:plantcare_pro/models/models.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:plantcare_pro/models/app_state.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  // Create an AppState instance and mark as logged in for deterministic tests.
  final appState = AppState();
  appState.isLoggedIn = true;
  await tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: appState,
      child: const PlantCareApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('local login flow reaches home', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await _pumpApp(tester);

      expect(find.text('Good Morning'), findsOneWidget);
      expect(find.text('Welcome back!'), findsOneWidget);
    });
  });

  testWidgets('plant detail and garden add flow work locally', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await _pumpApp(tester);

      // Ensure the Details button is visible (scroll if needed) then tap.
      await tester.ensureVisible(find.text('Details').first);
      await tester.tap(find.text('Details').first);
      await tester.pumpAndSettle();
      expect(find.text('Plant Details'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      // Tap the Plants stat card (tap the GestureDetector ancestor of the label).
      final plantsCard = find.ancestor(
        of: find.text('Plants'),
        matching: find.byType(GestureDetector),
      ).first;
      await tester.ensureVisible(plantsCard);
      await tester.tap(plantsCard);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(AppBar, 'Add Plant'), findsOneWidget);

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Test Fern');
      await tester.enterText(fields.at(1), 'Nephrolepis exaltata');
      await tester.enterText(fields.at(2), 'https://images.unsplash.com/photo-1593691509542-0f6f2c72b4f9?w=400');
      await tester.enterText(fields.at(3), 'Keep the soil lightly moist.');
      await tester.enterText(fields.at(4), 'Today');
      await tester.enterText(fields.at(5), 'In 4 days');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Plant'));
      await tester.pumpAndSettle();

      expect(find.text('Test Fern'), findsWidgets);
    });
  });

  testWidgets('invalid plant input shows validation errors', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await _pumpApp(tester);

      final plantsCard = find.ancestor(
        of: find.text('Plants'),
        matching: find.byType(GestureDetector),
      ).first;
      await tester.ensureVisible(plantsCard);
      await tester.tap(plantsCard);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Plant'));
      await tester.pumpAndSettle();

      expect(find.text('Required'), findsWidgets);
    });
  });

  testWidgets('settings and profile values persist locally', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await _pumpApp(tester);

      // Switch to Profile tab, then open Settings.
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.text('Vacation mode'));
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('Vacation Mode'), findsOneWidget);
    });
  });

  testWidgets('sign out returns to welcome screen', (WidgetTester tester) async {
    await mockNetworkImagesFor(() async {
      await _pumpApp(tester);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      final signOutButton = find.widgetWithText(TextButton, 'Sign Out');
      await tester.ensureVisible(signOutButton);
      await tester.tap(signOutButton);
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ElevatedButton, 'Get Started'), findsOneWidget);
      expect(find.text('Sign In'), findsNothing);
    });
  });

  testWidgets('local persistence reloads profile and plants', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'profile_v1': jsonEncode({
        'profileName': 'Ada Leaf',
        'profileEmoji': '🪴',
        'vacationMode': true,
        'notificationsEnabled': false,
      }),
      'plants_v1': jsonEncode([
        {
          'id': 'plant-42',
          'name': 'Test Fern',
          'species': 'Nephrolepis exaltata',
          'image': 'https://example.com/fern.png',
          'notes': 'Keep moist',
          'lastWatered': 'Today',
          'nextWatering': 'In 3 days',
          'health': PlantHealth.good.index,
          'level': 2,
        }
      ]),
    });

    final restoredState = AppState();
    for (var i = 0; i < 20; i++) {
      if (restoredState.profileName == 'Ada Leaf' &&
          restoredState.profileEmoji == '🪴' &&
          restoredState.getPlant('plant-42') != null) {
        break;
      }
      await tester.pump(const Duration(milliseconds: 50));
    }

    expect(restoredState.profileName, 'Ada Leaf');
    expect(restoredState.profileEmoji, '🪴');
    expect(restoredState.vacationMode, isTrue);
    expect(restoredState.notificationsEnabled, isFalse);
    expect(restoredState.getPlant('plant-42')?.name, 'Test Fern');
  });
}
