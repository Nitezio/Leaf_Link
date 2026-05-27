import 'dart:async';

class FakeAndroidImpl {
  final List _channels = [];
  Future<void> createNotificationChannel(dynamic channel) async {
    _channels.add(channel);
  }
}

class FakeFlutterLocalNotificationsPlugin {
  final List<Map<String, dynamic>> scheduled = [];
  final FakeAndroidImpl _androidImpl = FakeAndroidImpl();

  Future<void> initialize({dynamic settings}) async {
    // no-op
  }

  T? resolvePlatformSpecificImplementation<T>() {
    // Return a fake Android implementation when requested
    if (T.toString().contains('Android')) {
      return _androidImpl as T;
    }
    return null;
  }

  Future<void> zonedSchedule({
    required int id,
    String? title,
    String? body,
    required dynamic scheduledDate,
    required dynamic notificationDetails,
    dynamic androidScheduleMode,
    String? payload,
  }) async {
    scheduled.add({
      'id': id,
      'title': title,
      'body': body,
      'scheduledDate': scheduledDate,
      'payload': payload,
    });
  }

  Future<void> cancel({required int id}) async {
    scheduled.removeWhere((s) => s['id'] == id);
  }
}
