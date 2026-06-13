import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io' show File;
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/models.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../screens/growth_detector_screen.dart';
import 'plant_form_sheet.dart';

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
                  right: 48,
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
                // Edit / Delete Menu
                Positioned(
                  top: 4,
                  right: 4,
                  child: PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onSelected: (value) {
                      if (value == 'edit') {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (_) => PlantFormSheet(plant: plant),
                        );
                      } else if (value == 'delete') {
                        context.read<AppState>().deletePlant(plant.id);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete', style: TextStyle(color: AppColors.destructive)),
                      ),
                    ],
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
                          child: _WaterButton(
                            plant: plant,
                            onWater: () => onWater(plant.id),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GrowthDetectorScreen(plant: plant),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(color: AppColors.secondary),
                            foregroundColor: AppColors.secondary,
                            padding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          icon: Icon(Icons.auto_awesome, size: 16),
                          label: Text('Growth', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
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

class _WaterButton extends StatefulWidget {
  final Plant plant;
  final VoidCallback onWater;

  const _WaterButton({required this.plant, required this.onWater});

  @override
  State<_WaterButton> createState() => _WaterButtonState();
}

class _WaterButtonState extends State<_WaterButton> {
  Timer? _timer;
  late bool _recentlyWatered;
  String _countdownText = '';

  @override
  void initState() {
    super.initState();
    _updateState();
    // Update the button every second
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateState());
  }

  @override
  void didUpdateWidget(covariant _WaterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateState() {
    if (!mounted) return;
    
    String? isoString = widget.plant.lastWateredIso;
    if (isoString == null) {
      final waterEvents = widget.plant.careHistory.where((e) => e.type == 'water');
      if (waterEvents.isNotEmpty) {
        isoString = waterEvents.first.timestamp;
      }
    }
    
    if (isoString == null) {
      // Fallback for plants without iso date or care history
      setState(() {
        _recentlyWatered = widget.plant.lastWatered == 'Just now' || widget.plant.lastWatered == 'Today';
        _countdownText = _recentlyWatered ? 'Wait for next round' : 'Water Now';
      });
      return;
    }

    final lastWateredAt = DateTime.parse(isoString);
    final now = DateTime.now();
    final difference = now.difference(lastWateredAt);
    
    // 72 hours = 3 days cooldown
    if (difference.inHours >= 72) {
      setState(() {
        _recentlyWatered = false;
        _countdownText = 'Water Now';
      });
    } else {
      final remaining = const Duration(hours: 72) - difference;
      final days = remaining.inDays;
      final hours = remaining.inHours % 24;
      final minutes = remaining.inMinutes % 60;
      final seconds = remaining.inSeconds % 60;
      
      final parts = <String>[];
      if (days > 0) parts.add('${days}d');
      if (hours > 0 || days > 0) parts.add('${hours}h');
      parts.add('${minutes}m');
      parts.add('${seconds}s');
      
      setState(() {
        _recentlyWatered = true;
        _countdownText = 'Wait for next round\n${parts.join(' ')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      // using null correctly applies the disabled styling
      onPressed: _recentlyWatered ? null : widget.onWater,
      icon: Icon(_recentlyWatered ? Icons.timer_outlined : Icons.water_drop_outlined, size: 18),
      label: Text(
        _countdownText,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: _recentlyWatered ? 10 : 14, height: 1.2),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: _recentlyWatered ? Colors.amber : Colors.blue,
        disabledBackgroundColor: Colors.amber.withValues(alpha: 0.9),
        disabledForegroundColor: Colors.black87,
        foregroundColor: _recentlyWatered ? Colors.black87 : Colors.white,
        shape: const StadiumBorder(),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        shadowColor: (_recentlyWatered ? Colors.amber : Colors.blue).withValues(alpha: 0.2),
      ),
    );
  }
}

