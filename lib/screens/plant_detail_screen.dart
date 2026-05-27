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

  PlantDetailScreen({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final plant = state.getPlant(plantId);
    final scheduledFor = state.scheduledFor(plantId);

    if (plant == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          title: Text('Plant Details'),
        ),
        body: Center(child: Text('Plant not found.')),
      );
    }

    final statusLabel = switch (plant.health) {
      PlantHealth.excellent => 'Thriving',
      PlantHealth.good => 'Healthy',
      PlantHealth.warning => 'Needs Care',
    };

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        title: Text('Plant Details'),
        actions: [
          IconButton(
            onPressed: () async {
              final app = context.read<AppState>();
              final navigator = Navigator.of(context);
              final deleted = await showDialog<bool>(
                context: context,
                builder: (dctx) => AlertDialog(
                  title: Text('Delete plant?'),
                  content: Text('This will remove the plant from your garden.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dctx, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(dctx, true),
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
              if (deleted == true) {
                app.deletePlant(plantId);
                if (navigator.mounted) navigator.pop();
              }
            },
            icon: Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
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
                            child: Icon(Icons.eco, size: 60, color: Colors.white),
                          ),
                        )
                      : Image.file(
                          File(plant.image),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.chart4,
                            child: Icon(Icons.eco, size: 60, color: Colors.white),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16),
              Text(plant.name,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface)),
              SizedBox(height: 4),
              Text(plant.species,
                  style: TextStyle(
                      fontSize: 14, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
              SizedBox(height: 16),
              Row(
                children: [
                  _statChip(context, 'Status', statusLabel),
                  SizedBox(width: 10),
                  _statChip(context, 'Level', 'Lv ${plant.level}'),
                  SizedBox(width: 10),
                  _statChip(context, 'Water', plant.nextWatering),
                ],
              ),
              SizedBox(height: 16),
              _panel(
                context,
                title: 'Notes',
                child: Text(
                  plant.notes.isEmpty ? 'No notes saved yet.' : plant.notes,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(height: 12),
              _panel(
                context,
                title: 'Care Info',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Last watered: ${plant.lastWatered}'),
                    SizedBox(height: 4),
                    Text('Next watering: ${plant.nextWatering}'),
                  ],
                ),
              ),
              SizedBox(height: 12),
              _panel(
                context,
                title: 'Care History',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plant.careHistory.isEmpty)
                      Text('No care events yet.'),
                    for (final e in plant.careHistory)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              e.type == 'water' ? Icons.opacity : Icons.note,
                              color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.type == 'water' ? 'Watered' : e.type,
                                      style: TextStyle(fontWeight: FontWeight.w600)),
                                  SizedBox(height: 4),
                                  Text(e.note ?? '', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                                  SizedBox(height: 4),
                                  Text(e.timestamp, style: TextStyle(fontSize: 12, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                                ],
                              ),
                            ),
                            if (e.photoPath != null)
                              Padding(
                                padding: EdgeInsets.only(left: 8),
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
              SizedBox(height: 12),
              if (scheduledFor != null)
                SizedBox(height: 8),
              if (scheduledFor != null)
                _panel(
                  context,
                  title: 'Reminder',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Scheduled for: ${scheduledFor.toLocal()}'),
                      SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => context.read<AppState>().cancelScheduledWatering(plant.id),
                        style: OutlinedButton.styleFrom(
                          shape: StadiumBorder(),
                          side: BorderSide(color: Theme.of(context).colorScheme.outline),
                        ),
                        child: Text('Cancel Reminder'),
                      ),
                    ],
                  ),
                ),
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
                        shape: StadiumBorder(),
                        side: BorderSide(color: Theme.of(context).colorScheme.outline),
                      ),
                      child: Text('Edit Plant'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AppState>().waterPlant(plant.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Plant watered! +50 XP 🌱')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                      ),
                      child: Text('Water Now'),
                    ),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () async {
                      final appState = context.read<AppState>();
                      final messenger = ScaffoldMessenger.of(context);
                      // schedule a watering reminder: pick date then time
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 9, minute: 0),
                      );
                      if (time == null) return;
                      final scheduled = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                      await appState.scheduleWatering(plant.id, scheduled);
                      messenger.showSnackBar(SnackBar(content: Text('Reminder scheduled for ${scheduled.toLocal()}')));
                    },
                    style: OutlinedButton.styleFrom(
                      shape: StadiumBorder(),
                      side: BorderSide(color: Theme.of(context).colorScheme.outline),
                    ),
                    child: Text(scheduledFor == null ? 'Schedule Reminder' : 'Reschedule Reminder'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
            SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _panel(BuildContext context, {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface)),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
