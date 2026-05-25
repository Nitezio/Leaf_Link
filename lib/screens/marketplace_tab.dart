import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MarketplaceTab extends StatelessWidget {
  const MarketplaceTab({super.key});

  static const _items = [
    {
      'name': 'Peace Lily',
      'price': '\$18.99',
      'rating': '4.8',
      'seller': 'GreenShop',
      'emoji': '🌸',
      'badge': 'Best Seller',
    },
    {
      'name': 'ZZ Plant',
      'price': '\$24.99',
      'rating': '4.9',
      'seller': 'Urban Roots',
      'emoji': '🌿',
      'badge': 'Popular',
    },
    {
      'name': 'Bird of Paradise',
      'price': '\$45.00',
      'rating': '4.7',
      'seller': 'Leaf & Co.',
      'emoji': '🌴',
      'badge': null,
    },
    {
      'name': 'Fiddle Leaf Fig',
      'price': '\$39.99',
      'rating': '4.6',
      'seller': 'Plant Haven',
      'emoji': '🌳',
      'badge': 'New',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Text(
              'Marketplace',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              ),
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 14),
                  Icon(Icons.search_rounded, color: AppColors.mutedForeground, size: 20),
                  SizedBox(width: 10),
                  Text('Search plants & supplies…',
                      style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Plants', 'Pots', 'Soil', 'Tools', 'Seeds'].map((c) {
                final selected = c == 'All';
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.foreground,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: _items.length,
            itemBuilder: (context, i) => _ItemCard(item: _items[i]),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
              Container(
                height: 110,
                color: AppColors.chart4,
                child: Center(
                  child: Text(item['emoji'], style: const TextStyle(fontSize: 52)),
                ),
              ),
              if (item['badge'] != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item['badge'],
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.foreground)),
                const SizedBox(height: 2),
                Text(item['seller'],
                    style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['price'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primary)),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, size: 13, color: AppColors.gold),
                        const SizedBox(width: 2),
                        Text(item['rating'],
                            style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
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
