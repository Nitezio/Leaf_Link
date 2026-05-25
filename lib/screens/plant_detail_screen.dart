import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'add_edit_plant_screen.dart';

class PlantDetailScreen extends StatelessWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final plant = state.getPlant(plantId);

    if (plant == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.foreground,
          title: const Text('Plant Details'),
        ),
        body: const Center(child: Text('Plant not found.')),
      );
    }

    final statusLabel = switch (plant.health) {
      PlantHealth.excellent => 'Thriving',
      PlantHealth.good => 'Healthy',
      PlantHealth.warning => 'Needs Care',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        title: const Text('Plant Details'),
        actions: [
          IconButton(
            onPressed: () async {
                final appState = context.read<AppState>();
                final navigator = Navigator.of(context);
              final deleted = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete plant?'),
                  content: const Text('This will remove the plant from your garden.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (deleted == true) {
                  appState.deletePlant(plantId);
                  navigator.pop();
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.network(
                    plant.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.chart4,
                      child: const Icon(Icons.eco, size: 60, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(plant.name,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.foreground)),
              const SizedBox(height: 4),
              Text(plant.species,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.mutedForeground)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _statChip('Status', statusLabel),
                  const SizedBox(width: 10),
                  _statChip('Level', 'Lv ${plant.level}'),
                  const SizedBox(width: 10),
                  _statChip('Water', plant.nextWatering),
                ],
              ),
              const SizedBox(height: 16),
              _panel(
                title: 'Notes',
                child: Text(
                  plant.notes.isEmpty ? 'No notes saved yet.' : plant.notes,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.foreground,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _panel(
                title: 'Care Info',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last watered: ${plant.lastWatered}'),
                    const SizedBox(height: 4),
                    Text('Next watering: ${plant.nextWatering}'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditPlantScreen(plant: plant),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: const Text('Edit Plant'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AppState>().waterPlant(plant.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Plant watered! +50 XP 🌱')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text('Water Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.mutedForeground)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: AppColors.foreground)),
          ],
        ),
      ),
    );
  }

  Widget _panel({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.foreground)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
