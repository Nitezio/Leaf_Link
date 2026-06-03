import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme/app_theme.dart';

class ArPreviewScreen extends StatefulWidget {
  const ArPreviewScreen({super.key});

  @override
  State<ArPreviewScreen> createState() => _ArPreviewScreenState();
}

class _ArPreviewScreenState extends State<ArPreviewScreen> {
  // Using an official realistic potted plant model from Khronos glTF-Sample-Assets, downloaded locally for offline & web support
  final String plantModelUrl = 'assets/models/plant.glb';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('AR Plant Placement', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  // The 3D Viewer - Fully relying on robust native touch controls
                  ModelViewer(
                    backgroundColor: Colors.transparent,
                    src: plantModelUrl,
                    alt: 'A 3D model of a plant',
                    ar: true,
                    arModes: const ['scene-viewer', 'quick-look'],
                    autoRotate: true,
                    cameraControls: true,
                  ),
                  
                  // Top Hint overlay
                  Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pinch to scale, drag to rotate',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                    
                  // Bottom AR Hint
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tap the AR button on the bottom right',
                          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
