import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

enum DetectorState { initial, scanning, results }

class GrowthDetectorScreen extends StatefulWidget {
  final Plant plant;

  const GrowthDetectorScreen({super.key, required this.plant});

  @override
  State<GrowthDetectorScreen> createState() => _GrowthDetectorScreenState();
}

class _GrowthDetectorScreenState extends State<GrowthDetectorScreen> with SingleTickerProviderStateMixin {
  DetectorState _state = DetectorState.initial;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  
  late AnimationController _scanController;
  
  // Mock results
  int _growthScore = 0;
  String _assessment = '';
  String _action = '';

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() {
          _imageFile = picked;
          _state = DetectorState.scanning;
        });
        _startScanning();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  void _startScanning() {
    _scanController.repeat(reverse: true);
    // Simulate AI processing delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _scanController.stop();
        _generateMockResults();
        setState(() {
          _state = DetectorState.results;
        });
      }
    });
  }

  void _generateMockResults() {
    final random = Random();
    _growthScore = 70 + random.nextInt(26); // 70 to 95
    
    final assessments = [
      'The leaves are vibrant and showing excellent growth density.',
      'Slight paleness in newer leaves indicates a mild nutrient deficiency.',
      'Stem structure is strong, but some tips show minor drying.',
      'Perfect moisture levels detected. Growth is perfectly on track!',
    ];
    final actions = [
      'Maintain current watering schedule.',
      'Apply a mild liquid fertilizer during the next watering.',
      'Consider misting the leaves every few days to increase humidity.',
      'Rotate the plant slightly to encourage even sunlight exposure.',
    ];
    
    _assessment = assessments[random.nextInt(assessments.length)];
    _action = actions[random.nextInt(actions.length)];
  }

  void _saveAndClose() {
    final note = 'Growth Score: $_growthScore/100\nAssessment: $_assessment\nRecommendation: $_action';
    
    final newEvent = CareEvent(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: 'growth_analysis',
      timestamp: DateTime.now().toIso8601String(),
      note: note,
      photoPath: _imageFile?.path,
    );
    
    final updatedHistory = List<CareEvent>.from(widget.plant.careHistory)..add(newEvent);
    final updatedPlant = widget.plant.copyWith(careHistory: updatedHistory);
    
    context.read<AppState>().updatePlant(updatedPlant);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report saved to history!'), backgroundColor: AppColors.secondary),
    );
    Navigator.of(context).pop();
  }

  Widget _buildImagePreview() {
    if (_imageFile == null) {
      return Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.image_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
      );
    }
    
    Widget imageWidget;
    if (kIsWeb) {
      imageWidget = Image.network(_imageFile!.path, fit: BoxFit.cover);
    } else {
      imageWidget = Image.file(File(_imageFile!.path), fit: BoxFit.cover);
    }
    
    return Container(
      height: 300,
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          if (_state == DetectorState.scanning)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Positioned(
                  top: _scanController.value * 300 - 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.secondary.withValues(alpha: 0.0),
                          AppColors.secondary.withValues(alpha: 0.8),
                          AppColors.secondary.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: 2,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Growth Detector ✨'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background subtle gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  AppColors.primary.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Analyze ${widget.plant.name}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Provide a photo for AI analysis',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  
                  _buildImagePreview(),
                  SizedBox(height: 32),
                  
                  if (_state == DetectorState.initial) ...[
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library),
                      label: Text('Upload from Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                        shape: StadiumBorder(),
                      ),
                    ),
                  ],
                  
                  if (_state == DetectorState.scanning) ...[
                    Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: AppColors.secondary),
                          SizedBox(height: 16),
                          Text(
                            'AI is analyzing your plant...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  if (_state == DetectorState.results) ...[
                    Card(
                      elevation: 4,
                      shadowColor: AppColors.primary.withValues(alpha: 0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'AI Report Card',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _growthScore >= 80 ? AppColors.secondary.withValues(alpha: 0.2) : Colors.orange.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Score: $_growthScore/100',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _growthScore >= 80 ? AppColors.secondary : Colors.orange.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(height: 32),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.analytics_outlined, color: AppColors.primary),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Assessment', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                      SizedBox(height: 4),
                                      Text(_assessment, style: TextStyle(fontSize: 14, height: 1.4)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.lightbulb_outline, color: AppColors.secondary),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Recommendation', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                      SizedBox(height: 4),
                                      Text(_action, style: TextStyle(fontSize: 14, height: 1.4)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _saveAndClose,
                      icon: Icon(Icons.save_outlined),
                      label: Text('Save to History'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                      ),
                    ),
                    SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _state = DetectorState.initial;
                          _imageFile = null;
                        });
                      },
                      child: Text('Scan Again'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
