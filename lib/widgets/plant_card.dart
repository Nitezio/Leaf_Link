import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/models.dart';
import '../theme/app_theme.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final Function(String) onWater;
  final Function(String) onScan;
  final VoidCallback? onTap;

  PlantCard({
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
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
                // Support both network images and local file paths (picked from gallery).
                if (!kIsWeb && plant.image.isNotEmpty && !plant.image.startsWith('http'))
                  Image.file(File(plant.image), fit: BoxFit.cover)
                else
                  CachedNetworkImage(
                    imageUrl: plant.image,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.chart4),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.chart4, child: Icon(Icons.eco, size: 48, color: Colors.white)),
                  ),
                // Gradient
                Container(
                  decoration: BoxDecoration(
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cfg['icon']!, style: TextStyle(fontSize: 13)),
                        SizedBox(width: 4),
                        Text(
                          cfg['text']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded, size: 12, color: AppColors.secondary),
                        SizedBox(width: 3),
                        Text(
                          'Lv.${plant.level}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
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
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        plant.species,
                        style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Card body
          Padding(
            padding: EdgeInsets.all(16),
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
                      child: Icon(Icons.water_drop_outlined, size: 16, color: AppColors.secondary),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next watering',
                          style: TextStyle(fontSize: 11, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                        ),
                        Text(
                          plant.nextWatering,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () => onWater(plant.id),
                          icon: Icon(Icons.water_drop_outlined, size: 18),
                          label: Text('Water Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                            elevation: 2,
                            shadowColor: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => onScan(plant.id),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
                        ),
                        child: Icon(Icons.camera_alt_outlined, size: 22, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                      SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(color: Theme.of(context).colorScheme.outline),
                            foregroundColor: Theme.of(context).colorScheme.onSurface,
                          ),
                          child: Text('Details'),
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

