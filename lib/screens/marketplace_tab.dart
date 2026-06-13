import 'package:flutter/material.dart' hide Badge;
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_body.dart';

class MarketplaceTab extends StatefulWidget {
  const MarketplaceTab({super.key});

  @override
  State<MarketplaceTab> createState() => _MarketplaceTabState();
}

class _MarketplaceTabState extends State<MarketplaceTab> {
  String _selectedCategory = 'All';
  String _search = '';

  static const _categories = ['All', 'Plants', 'Pots', 'Soil', 'Tools', 'Seeds'];

  List<MarketplaceItem> _filteredItems(AppState state) {
    final query = _search.trim().toLowerCase();
    return state.marketplaceItems.where((item) {
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.seller.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' ||
          (_selectedCategory == 'Plants' && item.stock > 0) ||
          (_selectedCategory == 'Pots' && item.badge == 'Popular') ||
          (_selectedCategory == 'Soil' && item.name.toLowerCase().contains('soil')) ||
          (_selectedCategory == 'Tools' && item.name.toLowerCase().contains('tool')) ||
          (_selectedCategory == 'Seeds' && item.name.toLowerCase().contains('seed'));
      return matchesQuery && matchesCategory;
    }).toList();
  }

  void _showCartSheet(BuildContext context, AppState state) {
    bool useToken = false;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(builder: (context, setStateSheet) {
          return Consumer<AppState>(builder: (context, stateInside, _) {
            final cart = stateInside.cartItems;
            final hasToken = stateInside.userStats.tokens > 0;
            if (!hasToken) useToken = false;

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  if (cart.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Your cart is empty. Add a plant to get started.',
                        style: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: cart.length,
                        separatorBuilder: (_, __) => SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final cartItem = cart[index];
                          return _CartRow(
                            item: cartItem,
                            onAdd: () => stateInside.incrementCartItem(cartItem.item.id),
                            onRemove: () => stateInside.decrementCartItem(cartItem.item.id),
                            onDelete: () => stateInside.removeFromCart(cartItem.item.id),
                          );
                        },
                      ),
                    ),
                  if (cart.isNotEmpty && hasToken) ...[
                    SizedBox(height: 8),
                    SwitchListTile(
                      title: Text('Use Daily Token (20% off)'),
                      subtitle: Text('Tokens available: ${stateInside.userStats.tokens}'),
                      value: useToken,
                      onChanged: (val) {
                        setStateSheet(() => useToken = val);
                      },
                      contentPadding: EdgeInsets.zero,
                      activeColor: AppColors.primary,
                    ),
                  ],
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: cart.isEmpty ? null : stateInside.clearCart,
                          style: OutlinedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(color: Theme.of(context).colorScheme.outline),
                          ),
                          child: Text('Clear Cart'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: cart.isEmpty
                              ? null
                              : () async {
                                  final navigator = Navigator.of(context);
                                  final messenger = ScaffoldMessenger.of(context);
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (dctx) => AlertDialog(
                                      title: Text('Confirm purchase'),
                                      content: Text('Buy ${stateInside.cartCount} item(s) from your cart?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(dctx, false), child: Text('Cancel')),
                                        TextButton(onPressed: () => Navigator.pop(dctx, true), child: Text('Buy')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    final ok = stateInside.checkoutCart(useToken: useToken);
                                    final receipt = stateInside.latestReceipt;
                                    messenger.showSnackBar(SnackBar(content: Text(ok ? 'Purchase successful' : 'Purchase failed: insufficient stock')));
                                    if (ok) navigator.pop();
                                    if (ok && receipt != null) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) {
                                          _showReceiptDialog(context, receipt);
                                        }
                                      });
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                          child: Text('Checkout (${stateInside.cartCount})'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
          });
        });
      },
    );
  }

  void _showItemDetails(BuildContext context, AppState state, MarketplaceItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final inCart = state.isInCart(item.id);
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(item.emoji, style: TextStyle(fontSize: 56)),
                SizedBox(height: 10),
                Text(item.name,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 4),
                Text('${item.seller} • ${item.rating} ★ • ${item.stock} in stock',
                    style: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                SizedBox(height: 12),
                Text(item.description,
                    style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          shape: StadiumBorder(),
                          side: BorderSide(color: Theme.of(context).colorScheme.outline),
                        ),
                        child: Text('Close'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          state.addToCart(item);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: StadiumBorder(),
                        ),
                        child: Text(inCart ? 'Add Another' : 'Add to Cart'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReceiptDialog(BuildContext context, PurchaseReceipt receipt) {
    showDialog<void>(
      context: context,
      builder: (dctx) => AlertDialog(
        title: Text('Receipt'),
        content: SizedBox(
          width: 360,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Purchased: ${receipt.purchasedAt}'),
                SizedBox(height: 12),
                for (final line in receipt.items)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Text(line.emoji, style: TextStyle(fontSize: 24)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(line.itemName, style: TextStyle(fontWeight: FontWeight.w600)),
                              Text('${line.quantity} x ${line.priceLabel}', style: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Divider(),
                Text('Total: ${receipt.totalLabel}', style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Text('Points earned: +${receipt.pointsAwarded}'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dctx), child: Text('Close')),
        ],
      ),
    );
  }

  void _showReceiptHistory(BuildContext context, List<PurchaseReceipt> receipts) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Receipts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
              ),
              SizedBox(height: 12),
              if (receipts.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text('No purchases yet.', style: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: receipts.length,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final receipt = receipts[index];
                      return ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).colorScheme.outline)),
                        tileColor: Theme.of(context).cardColor,
                        title: Text(receipt.totalLabel, style: TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('${receipt.totalItems} item(s) • ${receipt.purchasedAt}'),
                        trailing: Text('+${receipt.pointsAwarded}', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                        onTap: () => _showReceiptDialog(context, receipt),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final items = _filteredItems(state);

    return ResponsiveBody(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: state.cartCount > 0 ? 80.0 : 0.0), // padding for sticky bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Marketplace',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.stars_rounded, color: Colors.amber[600], size: 16),
                        SizedBox(width: 4),
                        Text(
                          '${state.userStats.tokens}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[700]),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showReceiptHistory(context, state.purchaseHistory),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.receipt_long_outlined, color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showCartSheet(context, state),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.shopping_cart_outlined,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        if (state.cartCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.destructive,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${state.cartCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (value) => setState(() => _search = value),
                decoration: InputDecoration(
                  hintText: 'Search plants & supplies…',
                  prefixIcon: Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Category chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((c) {
                  final selected = c == _selectedCategory;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedCategory = c),
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      backgroundColor: Theme.of(context).cardColor,
                      side: BorderSide(
                        color: selected ? AppColors.primary : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

            if (items.isEmpty)
              Padding(
                padding: EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    'No items match your search yet.',
                    style: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) => _ItemCard(
                  item: items[i],
                  onAddToCart: () => state.addToCart(items[i]),
                  onRemoveFromCart: () => state.decrementCartItem(items[i].id),
                  onOpenDetails: () => _showItemDetails(context, state, items[i]),
                  inCart: state.isInCart(items[i].id),
                  quantityInCart: state.getCartItemQuantity(items[i].id),
                ),
              ),

            SizedBox(height: 24),
          ],
        ),
      ),
    ),
    if (state.cartCount > 0)
      Positioned(
        bottom: 16,
        left: 16,
        right: 16,
        child: GestureDetector(
          onTap: () => _showCartSheet(context, state),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${state.cartCount} item(s)',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      'Total: ${state.cartTotalPriceLabel}',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('View Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    SizedBox(width: 8),
                    Icon(Icons.shopping_cart, color: Colors.white, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);
  }
}

class _ItemCard extends StatelessWidget {
  final MarketplaceItem item;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;
  final VoidCallback onOpenDetails;
  final bool inCart;
  final int quantityInCart;

  _ItemCard({
    required this.item,
    required this.onAddToCart,
    required this.onRemoveFromCart,
    required this.onOpenDetails,
    required this.inCart,
    required this.quantityInCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Stack(
            children: [
              GestureDetector(
                onTap: onOpenDetails,
                child: Container(
                height: 110,
                color: AppColors.chart4,
                child: Center(
                  child: Text(item.emoji, style: TextStyle(fontSize: 52)),
                ),
              ),
            ),
              if (item.badge != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onOpenDetails,
                  child: Text(item.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface)),
                ),
                SizedBox(height: 2),
                Text(item.seller,
                    style: TextStyle(
                        fontSize: 11, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.price,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.primary)),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 13, color: AppColors.gold),
                        SizedBox(width: 2),
                        Text(item.rating,
                            style: TextStyle(
                                fontSize: 11,
                                color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                if (quantityInCart > 0)
                  Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 16, color: Colors.white),
                          onPressed: onRemoveFromCart,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        Text(
                          '$quantityInCart',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 16, color: Colors.white),
                          onPressed: onAddToCart,
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  _CartRow({
    required this.item,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          Text(item.item.emoji, style: TextStyle(fontSize: 28)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.item.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 2),
                Text(item.item.price,
                    style: TextStyle(color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
              ],
            ),
          ),
          IconButton(onPressed: onRemove, icon: Icon(Icons.remove_circle_outline)),
          Text('${item.quantity}',
              style: TextStyle(fontWeight: FontWeight.w600)),
          IconButton(onPressed: onAdd, icon: Icon(Icons.add_circle_outline)),
          IconButton(onPressed: onDelete, icon: Icon(Icons.delete_outline)),
        ],
      ),
    );
  }
}

