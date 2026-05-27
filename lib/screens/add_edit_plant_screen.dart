import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../services/image_service.dart';
import '../services/storage_service.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AddEditPlantScreen extends StatefulWidget {
  final Plant? plant;

  AddEditPlantScreen({super.key, this.plant});

  @override
  State<AddEditPlantScreen> createState() => _AddEditPlantScreenState();
}

class _AddEditPlantScreenState extends State<AddEditPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _speciesCtrl;
  late final TextEditingController _imageCtrl;
  late final TextEditingController _notesCtrl;
  late final TextEditingController _lastWateredCtrl;
  late final TextEditingController _nextWateringCtrl;
  PlantHealth _health = PlantHealth.good;
  int _level = 1;

  @override
  void initState() {
    super.initState();
    final plant = widget.plant;
    _nameCtrl = TextEditingController(text: plant?.name ?? '');
    _speciesCtrl = TextEditingController(text: plant?.species ?? '');
    _imageCtrl = TextEditingController(text: plant?.image ?? '');
    _notesCtrl = TextEditingController(text: plant?.notes ?? '');
    _lastWateredCtrl = TextEditingController(text: plant?.lastWatered ?? 'Today');
    _nextWateringCtrl = TextEditingController(text: plant?.nextWatering ?? 'In 3 days');
    _health = plant?.health ?? PlantHealth.good;
    _level = plant?.level ?? 1;
  }

  Future<void> _pickImage() async {
    final path = await ImageService.pickFromGallery();
    if (path != null) {
      setState(() {
        _imageCtrl.text = path;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _speciesCtrl.dispose();
    _imageCtrl.dispose();
    _notesCtrl.dispose();
    _lastWateredCtrl.dispose();
    _nextWateringCtrl.dispose();
    super.dispose();
  }

  void _savePlant() {
    if (!_formKey.currentState!.validate()) return;
    final state = context.read<AppState>();
    Future<void> doSave() async {
      String imageVal = _imageCtrl.text.trim();
      if (imageVal.isNotEmpty && !imageVal.startsWith('http')) {
        try {
          final uploaded = await StorageService.uploadFile(imageVal);
          if (uploaded != null && uploaded.isNotEmpty) imageVal = uploaded;
        } catch (_) {}
      }
      final plant = Plant(
      id: widget.plant?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      species: _speciesCtrl.text.trim(),
      image: imageVal,
      notes: _notesCtrl.text.trim(),
      lastWatered: _lastWateredCtrl.text.trim(),
      nextWatering: _nextWateringCtrl.text.trim(),
      health: _health,
      level: _level,
    );
      if (widget.plant == null) {
        state.addPlant(plant);
      } else {
        state.updatePlant(plant);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    }
    doSave();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.plant != null;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        title: Text(isEditing ? 'Edit Plant' : 'Add Plant'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_imageCtrl.text.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 160,
                      width: double.infinity,
                      child: kIsWeb || _imageCtrl.text.startsWith('http')
                          ? Image.network(_imageCtrl.text, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.chart4, child: Icon(Icons.eco, size: 40, color: Colors.white)))
                          : Image.file(File(_imageCtrl.text), fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.chart4, child: Icon(Icons.eco, size: 40, color: Colors.white))),
                    ),
                  ),
                SizedBox(height: 12),
                _field(_nameCtrl, 'Plant name'),
                SizedBox(height: 12),
                _field(_speciesCtrl, 'Species'),
                SizedBox(height: 12),
                _field(_imageCtrl, 'Image URL or path', keyboardType: TextInputType.url),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo_library),
                    label: Text('Pick from gallery'),
                  ),
                ),
                SizedBox(height: 12),
                _field(_notesCtrl, 'Notes', maxLines: 3),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _field(_lastWateredCtrl, 'Last watered')),
                    SizedBox(width: 12),
                    Expanded(child: _field(_nextWateringCtrl, 'Next watering')),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<PlantHealth>(
                        initialValue: _health,
                        decoration: _inputDecoration('Health'),
                        items: PlantHealth.values
                            .map((health) => DropdownMenuItem(
                                  value: health,
                                  child: Text(health.name),
                                ))
                            .toList(),
                        onChanged: (value) => setState(() => _health = value ?? _health),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: AppColors.primary,
                          thumbColor: AppColors.primary,
                        ),
                        child: Slider(
                          min: 1,
                          max: 10,
                          divisions: 9,
                          value: _level.toDouble(),
                          label: 'Lv $_level',
                          onChanged: (value) => setState(() => _level = value.round()),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _savePlant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: StadiumBorder(),
                    ),
                    child: Text(isEditing ? 'Save Changes' : 'Add Plant'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}
