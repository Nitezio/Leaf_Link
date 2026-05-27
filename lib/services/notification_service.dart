import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  dynamic _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _supported = true;
  bool _testMode = false;

  /// Enable test mode to skip platform plugin initialization (used in unit tests).
  /// Replace the underlying plugin instance for tests with a fake implementation.
  @visibleForTesting
  void setTestPlugin(dynamic plugin) {
    _plugin = plugin;
    // Ensure timezone data is available for tests that schedule notifications.
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('UTC'));
    } catch (_) {}
    _initialized = true;
    _supported = true;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    if (_testMode) {
      _initialized = true;
      _supported = false;
      return;
    }
    _initialized = true;
    if (kIsWeb) {
      _supported = false;
      return;
    }

    tz.initializeTimeZones();
    try {
      final dynamic localTzRaw = await FlutterTimezone.getLocalTimezone();
      String? localTzName;
      if (localTzRaw is String) {
        localTzName = localTzRaw;
      } else {
        try {
          localTzName = (localTzRaw as dynamic).name as String?;
        } catch (_) {
          try {
            localTzName = (localTzRaw as dynamic).timeZone as String?;
          } catch (_) {
            localTzName = localTzRaw.toString();
          }
        }
      }
      if (localTzName != null && localTzName.isNotEmpty) {
        tz.setLocalLocation(tz.getLocation(localTzName));
      }
    } catch (_) {
      // Leave tz.local as-is when the platform timezone cannot be resolved.
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(defaultActionName: 'Open reminder'),
    );

    try {
      await _plugin.initialize(settings: initializationSettings);
    } catch (_) {
      _supported = false;
    }

    // create Android notification channel (best-effort)
    try {
      final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImpl != null) {
        const channel = AndroidNotificationChannel(
          'watering_reminders',
          'Watering reminders',
          description: 'Reminders for watering plants',
          importance: Importance.max,
        );
        await androidImpl.createNotificationChannel(channel);
      }
    } catch (_) {}
  }

  int _notificationIdFor(String id) {
    var value = 0;
    for (final unit in id.codeUnits) {
      value = (value * 31 + unit) & 0x7fffffff;
    }
    return value;
  }

  Future<void> scheduleNotification(String id, String title, String body, DateTime when) async {
    await initialize();
    if (!_supported) return;
    final scheduled = tz.TZDateTime.from(when, tz.local);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'watering_reminders',
        'Watering reminders',
        channelDescription: 'Reminders for watering plants',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      macOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
      linux: const LinuxNotificationDetails(defaultActionName: 'Open reminder'),
    );

    await _plugin.zonedSchedule(
      id: _notificationIdFor(id),
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: id,
    );
  }

  Future<void> cancelNotification(String id) async {
    await initialize();
    if (!_supported) return;
    try {
      await _plugin.cancel(id: _notificationIdFor(id));
    } catch (_) {
      // ignore platform errors in test or uninitialized environments
    }
  }
}
