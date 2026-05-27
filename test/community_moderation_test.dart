import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_pro/models/app_state.dart';
import 'package:plantcare_pro/services/notification_service.dart';
import 'fakes/fake_flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
    (call) async {
      if (call.method == 'read') return null;
      return null;
    },
  );
  NotificationService.instance.setTestPlugin(FakeFlutterLocalNotificationsPlugin());

  test('reporting and hiding a community post updates moderation state', () {
    final state = AppState();
    final post = state.communityPosts.firstWhere((item) => item.userName != 'You');

    state.toggleCommunityReport(post.id);
    expect(state.getCommunityPost(post.id)?.reportCount, 1);
    expect(state.getCommunityPost(post.id)?.reportedByMe, isTrue);

    state.toggleCommunityHidden(post.id);
    expect(state.getCommunityPost(post.id)?.hidden, isTrue);

    state.clearCommunityModeration(post.id);
    expect(state.getCommunityPost(post.id)?.reportCount, 0);
    expect(state.getCommunityPost(post.id)?.hidden, isFalse);
    expect(state.getCommunityPost(post.id)?.reportedByMe, isFalse);
  });
}
