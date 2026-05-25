import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantcare_pro/models/app_state.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('sign out sets flags and persistence', () async {
    final state = AppState();
    // ensure logged in via public API which persists session
    await state.authenticateLocal(email: 'user@example.com', password: 'password', isSignup: false);

    await state.signOutLocal();

    expect(state.isLoggedIn, isFalse);
    expect(state.sessionEmail, isNull);
    expect(state.justSignedOut, isTrue);
  });

  test('persistence loads and saves profile', () async {
    final state = AppState();
    state.updateProfile(name: 'Ada Leaf', emoji: '🪴');
    state.setVacationMode(true);
    state.setNotificationsEnabled(false);

    // Create a new AppState which will load persisted profile
    final restored = AppState();

    // wait for background loads
    await Future.delayed(const Duration(milliseconds: 200));

    expect(restored.profileName, 'Ada Leaf');
    expect(restored.profileEmoji, '🪴');
    expect(restored.vacationMode, isTrue);
    expect(restored.notificationsEnabled, isFalse);
  });
}
