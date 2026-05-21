import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/plant.dart';
import '../core/theme/app_colors.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final VoidCallback onWater;
  final VoidCallback onScan;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onWater,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero Image with overlays
          SizedBox(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: plant.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: AppColors.muted),
                  errorWidget: (context, url, error) => Container(color: AppColors.muted, child: const Icon(Icons.error)),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.6),
                      ],
                    ),
                  ),
                ),
                // Health Badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: _buildHealthBadge(),
                ),
                // Level Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildLevelBadge(context),
                ),
                // Name Overlay
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                      Text(
                        plant.species,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info and Actions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Next Watering Info
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.droplets, color: AppColors.secondary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next watering',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedForeground),
                      ),
                      Text(
                        plant.nextWatering,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onWater,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                    ),
                    child: const Text('Water Now'),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(LucideIcons.camera, color: AppColors.primary),
                    onPressed: onScan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBadge() {
    Color bgColor;
    String label;
    String emoji;

    switch (plant.health) {
      case PlantHealth.excellent:
        bgColor = AppColors.healthExcellent;
        label = 'Thriving';
        emoji = '✨';
        break;
      case PlantHealth.good:
        bgColor = AppColors.healthGood;
        label = 'Healthy';
        emoji = '🌿';
        break;
      case PlantHealth.warning:
        bgColor = AppColors.healthWarning;
        label = 'Needs Care';
        emoji = '💧';
        break;
      case PlantHealth.critical:
        bgColor = AppColors.healthCritical;
        label = 'Critical';
        emoji = '🚨';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(LucideIcons.sparkles, size: 14, color: AppColors.gold),
          const SizedBox(width: 4),
          Text(
            'Lv.${plant.level}',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
