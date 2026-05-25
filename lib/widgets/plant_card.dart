import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final Function(String) onWater;
  final Function(String) onScan;
  final VoidCallback? onTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.onWater,
    required this.onScan,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cfg = _healthConfig[plant.health]!;

    final card = Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Hero image
          SizedBox(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: plant.image,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.chart4),
                  errorWidget: (_, __, ___) =>
                      Container(color: AppColors.chart4, child: const Icon(Icons.eco, size: 48, color: Colors.white)),
                ),
                // Gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x33000000), Color(0x99000000)],
                      stops: [0.0, 0.4, 1.0],
                    ),
                  ),
                ),
                // Health badge (top left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cfg['icon']!, style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 4),
                        Text(
                          cfg['text']!,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Level badge (top right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, size: 12, color: AppColors.secondary),
                        const SizedBox(width: 3),
                        Text(
                          'Lv.${plant.level}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Plant name
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        plant.species,
                        style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.water_drop_outlined, size: 16, color: AppColors.secondary),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next watering',
                          style: TextStyle(fontSize: 11, color: AppColors.mutedForeground),
                        ),
                        Text(
                          plant.nextWatering,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.foreground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => onWater(plant.id),
                          icon: const Icon(Icons.water_drop_outlined, size: 18),
                          label: const Text('Water Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            elevation: 2,
                            shadowColor: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onScan(plant.id),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 22, color: AppColors.foreground),
                      ),
                    ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: const BorderSide(color: AppColors.border),
                            foregroundColor: AppColors.foreground,
                          ),
                          child: const Text('Details'),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

      return GestureDetector(onTap: onTap, child: card);
  }

  static const _healthConfig = {
    PlantHealth.excellent: {'text': 'Thriving', 'icon': '✨'},
    PlantHealth.good: {'text': 'Healthy', 'icon': '🌿'},
    PlantHealth.warning: {'text': 'Needs Care', 'icon': '💧'},
  };
}

