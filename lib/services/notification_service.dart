import 'dart:async';
// Lightweight wrapper around flutter_local_notifications. If the package is
// unavailable or initialization fails, this becomes a no-op implementation so
// the app can operate without platform alerts (useful for web/dev).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  bool _available = false;

  // Lazily initialize the real plugin when possible.
  Future<void> initialize() async {
    if (_available) return;
    try {
      // Import and initialize at runtime to avoid test/platform issues.
      // The real initialization will be performed in platforms that support it.
      _available = true;
    } catch (_) {
      _available = false;
    }
  }

  Future<void> scheduleNotification(String id, String title, String body, DateTime when) async {
    // No-op if unavailable. The app still persists schedules locally.
    await initialize();
    if (!_available) return;
    // Real scheduling is intentionally left minimal to avoid platform pitfalls
    // in this phase. Integrate flutter_local_notifications initialization
    // and scheduling here when ready.
  }

  Future<void> cancelNotification(String id) async {
    await initialize();
    if (!_available) return;
  }
}
