import 'package:flutter_test/flutter_test.dart';
import 'package:plantcare_pro/models/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  const MethodChannel('plugins.it_nomads.com/flutter_secure_storage')
      .setMockMethodCallHandler((call) async {
    if (call.method == 'read') return null;
    return null;
  });

  test('checkout reduces stock and clears cart', () {
    final state = AppState();
    final item = state.marketplaceItems.first;
    final initialStock = item.stock;
    state.addToCart(item);
    final ok = state.checkoutCart();
    expect(ok, isTrue);
    expect(item.stock, initialStock - 1);
    expect(state.cartCount, 0);
  });
}
