import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Marketplace', style: Theme.of(context).textTheme.displayMedium),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                  child: const Icon(LucideIcons.plus, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search seeds, cuttings...',
                prefixIcon: const Icon(LucideIcons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
                filled: true,
                fillColor: AppColors.card,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                const SizedBox(width: 8),
                _buildFilterChip('Seeds', false),
                const SizedBox(width: 8),
                _buildFilterChip('Cuttings', false),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildListing('Monstera Deliciosa seeds', 'GreenThumb92', '2.3km', 12, 'Seeds'),
                _buildListing('Pothos Golden cuttings', 'PlantLover', '3.7km', 8, 'Cuttings'),
                _buildListing('Basil seeds', 'HerbGarden', '1.2km', 15, 'Seeds'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.card,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? AppColors.primary : AppColors.border),
      ),
      child: Text(
        label,
        style: TextStyle(color: active ? Colors.white : AppColors.foreground, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildListing(String title, String user, String distance, int likes, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.image, color: AppColors.mutedForeground),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(type, style: const TextStyle(color: AppColors.secondary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('By $user', style: TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(distance, style: const TextStyle(fontSize: 12)),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(minimumSize: const Size(80, 32), padding: EdgeInsets.zero),
                      child: const Text('Message', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
