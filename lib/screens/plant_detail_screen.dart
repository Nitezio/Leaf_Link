import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
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
              final app = context.read<AppState>();
              final navigator = Navigator.of(context);
              final deleted = await showDialog<bool>(
                context: context,
                builder: (dctx) => AlertDialog(
                  title: const Text('Delete plant?'),
                  content: const Text('This will remove the plant from your garden.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dctx, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dctx, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (deleted == true) {
                app.deletePlant(plantId);
                if (navigator.mounted) navigator.pop();
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
                  child: kIsWeb || plant.image.startsWith('http')
                      ? Image.network(
                          plant.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.chart4,
                            child: const Icon(Icons.eco, size: 60, color: Colors.white),
                          ),
                        )
                      : Image.file(
                          File(plant.image),
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
              _panel(
                title: 'Care History',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plant.careHistory.isEmpty)
                      const Text('No care events yet.'),
                    for (final e in plant.careHistory)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              e.type == 'water' ? Icons.opacity : Icons.note,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.type == 'water' ? 'Watered' : e.type,
                                      style: const TextStyle(fontWeight: FontWeight.w600)),
                                  const SizedBox(height: 4),
                                  Text(e.note ?? '', style: const TextStyle(color: AppColors.foreground)),
                                  const SizedBox(height: 4),
                                  Text(e.timestamp, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                                ],
                              ),
                            ),
                            if (e.photoPath != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: kIsWeb || e.photoPath!.startsWith('http')
                                      ? Image.network(e.photoPath!, fit: BoxFit.cover)
                                      : Image.file(File(e.photoPath!), fit: BoxFit.cover),
                                ),
                              ),
                          ],
                        ),
                      ),
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
                  const SizedBox(width: 8),
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
                  const SizedBox(width: 8),
                  OutlinedButton(
                    // ignore: use_build_context_synchronously
                    onPressed: () async {
                      final appState = context.read<AppState>();
                      final messenger = ScaffoldMessenger.of(context);
                      final ctx = context;
                      // schedule a watering reminder: pick date then time
                      // ignore: use_build_context_synchronously
                      final date = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date == null) return;
                      // ignore: use_build_context_synchronously
                      final time = await showTimePicker(
                        context: ctx,
                        initialTime: const TimeOfDay(hour: 9, minute: 0),
                      );
                      if (time == null) return;
                      final scheduled = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      await appState.scheduleWatering(plant.id, scheduled);
                      messenger.showSnackBar(SnackBar(content: Text('Reminder scheduled for ${scheduled.toLocal()}')));
                    },
                    style: OutlinedButton.styleFrom(
                      shape: const StadiumBorder(),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: const Text('Schedule Reminder'),
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
