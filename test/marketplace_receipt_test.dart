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

  test('checkout stores a receipt in history', () {
    final state = AppState();
    final item = state.marketplaceItems.first;
    state.addToCart(item);
    final ok = state.checkoutCart();

    expect(ok, isTrue);
    expect(state.latestReceipt, isNotNull);
    expect(state.purchaseHistory, isNotEmpty);

    final receipt = state.latestReceipt!;
    expect(receipt.totalItems, 1);
    expect(receipt.items.first.itemId, item.id);
    expect(receipt.pointsAwarded, 10);
  });
}
