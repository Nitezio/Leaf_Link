import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class PlantFormSheet extends StatefulWidget {
  final Plant? plant;

  const PlantFormSheet({super.key, this.plant});

  @override
  State<PlantFormSheet> createState() => _PlantFormSheetState();
}

class _PlantFormSheetState extends State<PlantFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _species;
  late String _notes;
  late String _image;

  @override
  void initState() {
    super.initState();
    _name = widget.plant?.name ?? '';
    _species = widget.plant?.species ?? '';
    _notes = widget.plant?.notes ?? '';
    _image = widget.plant?.image ?? 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=400';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final state = context.read<AppState>();
      
      if (widget.plant == null) {
        // Add
        final newPlant = Plant(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          name: _name,
          species: _species,
          notes: _notes,
          image: _image,
          lastWatered: 'Just now',
          nextWatering: 'In 3 days',
          health: PlantHealth.good,
          level: 1,
        );
        state.addPlant(newPlant);
      } else {
        // Edit
        final updated = widget.plant!.copyWith(
          name: _name,
          species: _species,
          notes: _notes,
          image: _image,
        );
        state.updatePlant(updated);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.plant != null;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isEditing ? 'Edit Plant' : 'Add New Plant',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Plant Name (e.g. Ferny)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _name = val!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _species,
                decoration: InputDecoration(
                  labelText: 'Species (e.g. Boston Fern)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _species = val!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _image,
                decoration: InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _image = val!.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _notes,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (val) => _notes = val?.trim() ?? '',
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submit,
                child: Text(
                  isEditing ? 'Save Changes' : 'Add Plant',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
