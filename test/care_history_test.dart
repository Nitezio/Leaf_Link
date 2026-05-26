import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantcare_pro/models/app_state.dart';
import 'package:plantcare_pro/models/models.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('watering adds care event and updates points and streak', () async {
    final state = AppState();
    // allow background loads to finish
    await Future.delayed(const Duration(milliseconds: 200));

    final initialPoints = state.userStats.points;

    state.waterPlant('1');

    final plant = state.getPlant('1')!;
    expect(plant.careHistory.isNotEmpty, isTrue);
    expect(plant.careHistory.first.type, 'water');
    expect(state.userStats.points, initialPoints + 50);
    expect(state.userStats.streak, 1);

    // watering again same day should not increase streak
    state.waterPlant('1');
    expect(state.userStats.streak, 1);
  });

  test('add care event with photo is stored', () async {
    final state = AppState();
    await Future.delayed(const Duration(milliseconds: 200));
    final event = CareEvent(
      id: 'evt-1',
      type: 'photo',
      timestamp: DateTime.now().toIso8601String(),
      photoPath: 'path/to/photo.jpg',
    );
    state.addCareEvent('1', event);
    final plant = state.getPlant('1')!;
    expect(plant.careHistory.first.photoPath, 'path/to/photo.jpg');
  });
}
