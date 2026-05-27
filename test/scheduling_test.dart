import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_pro/models/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:plantcare_pro/services/notification_service.dart';
import 'fakes/fake_flutter_local_notifications.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (call) async {
    if (call.method == 'read') return null;
    return null;
  },);
  // disable notifications plugin during tests
  NotificationService.instance.setTestPlugin(FakeFlutterLocalNotificationsPlugin());

  test('scheduling updates plant nextWatering and scheduledFor', () async {
    final state = AppState();
    final plantId = state.plants.first.id;
    final when = DateTime.now().add(const Duration(days: 2));
    await state.scheduleWatering(plantId, when);
    final scheduled = state.scheduledFor(plantId);
    expect(scheduled, isNotNull);
    if (scheduled == null) {
      fail('Expected a scheduled watering time');
    }
    expect(scheduled.difference(when).inSeconds.abs(), lessThan(2));
    final plant = state.getPlant(plantId)!;
    expect(plant.nextWatering, isNotNull);
    expect(plant.nextWatering.isNotEmpty, isTrue);
  });
}
