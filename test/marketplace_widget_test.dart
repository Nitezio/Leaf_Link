import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantcare_pro/models/app_state.dart';
import 'package:plantcare_pro/screens/marketplace_tab.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('search filters items and add to cart then open cart sheet', (tester) async {
    final state = AppState();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: Scaffold(body: MarketplaceTab())),
      ),
    );

    await tester.pumpAndSettle();

    // Ensure marketplace title present
    expect(find.text('Marketplace'), findsOneWidget);

    // Grab first item name from state
    final firstItemName = state.marketplaceItems.first.name;

    // Enter search for the first item name
    final searchField = find.byType(TextField).at(0);
    await tester.enterText(searchField, firstItemName.substring(0, 4));
    await tester.pumpAndSettle();

    // Expect the item to be visible
    expect(find.text(firstItemName), findsWidgets);

    // Tap 'Add to Cart' button for the first visible item
    final addButtons = find.text('Add to Cart');
    expect(addButtons, findsWidgets);
    await tester.tap(addButtons.first);
    await tester.pumpAndSettle();

    // Open cart sheet
    final cartIcon = find.byIcon(Icons.shopping_cart_outlined);
    expect(cartIcon, findsOneWidget);
    await tester.tap(cartIcon);
    await tester.pumpAndSettle();

    // Cart sheet should show the item (may also appear in the background list)
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text(firstItemName), findsWidgets);

    // Increase quantity
    final addIcon = find.byIcon(Icons.add_circle_outline).first;
    await tester.tap(addIcon);
    await tester.pumpAndSettle();

    // Quantity label should show 2
    expect(find.text('2'), findsWidgets);

    // Remove one
    final removeIcon = find.byIcon(Icons.remove_circle_outline).first;
    await tester.tap(removeIcon);
    await tester.pumpAndSettle();

    expect(find.text('1'), findsWidgets);

    // Clear cart and verify state updated
    final clearButton = find.text('Clear Cart');
    expect(clearButton, findsOneWidget);
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(state.cartItems.isEmpty, isTrue);
  });
}
