import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class AddEditPlantScreen extends StatefulWidget {
  final Plant? plant;

  const AddEditPlantScreen({super.key, this.plant});

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
    final plant = Plant(
      id: widget.plant?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      species: _speciesCtrl.text.trim(),
      image: _imageCtrl.text.trim(),
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
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.plant != null;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        title: Text(isEditing ? 'Edit Plant' : 'Add Plant'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _field(_nameCtrl, 'Plant name'),
                const SizedBox(height: 12),
                _field(_speciesCtrl, 'Species'),
                const SizedBox(height: 12),
                _field(_imageCtrl, 'Image URL', keyboardType: TextInputType.url),
                const SizedBox(height: 12),
                _field(_notesCtrl, 'Notes', maxLines: 3),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _field(_lastWateredCtrl, 'Last watered')),
                    const SizedBox(width: 12),
                    Expanded(child: _field(_nextWateringCtrl, 'Next watering')),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<PlantHealth>(
                        value: _health,
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
                    const SizedBox(width: 12),
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
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _savePlant,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
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
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }
}
