import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/gemini_service.dart';
import '../services/image_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/responsive_body.dart';

class ScanTab extends StatefulWidget {
  ScanTab({super.key});

  @override
  State<ScanTab> createState() => _ScanTabState();
}

class _ScanTabState extends State<ScanTab> {
  final List<ScanResult> _recentScans = [];

  void _addScan(ScanResult result) {
    setState(() {
      _recentScans.insert(0, result);
      if (_recentScans.length > 4) {
        _recentScans.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBody(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          children: [
            _DiseaseDetection(onScanComplete: _addScan),
            SizedBox(height: 16),
            _ARPlantPlacement(onLaunchAr: _addScan),
            SizedBox(height: 16),
            _GrowthPredictor(),
            SizedBox(height: 16),
            _RecentScansCard(recentScans: _recentScans),
          ],
        ),
      ),
    );
  }
}

class _DiseaseDetection extends StatefulWidget {
  final ValueChanged<ScanResult> onScanComplete;

  _DiseaseDetection({required this.onScanComplete});

  @override
  State<_DiseaseDetection> createState() => _DiseaseDetectionState();
}

class _DiseaseDetectionState extends State<_DiseaseDetection> {
    bool _scanned = false;
    bool _isAnalyzing = false;
    String? _analysisError;
    String? _analysisText;

  void _resetScanResult() {
    setState(() {
      _scanned = false;
      _analysisText = null;
      _analysisError = null;
    });
  }

    Future<void> _pickAndAnalyzeImage(ImageSource source) async {
      setState(() {
        _isAnalyzing = true;
        _analysisError = null;
        _analysisText = null;
      });

      try {
        final XFile? xfile = source == ImageSource.camera
            ? await ImageService.pickXFileFromCamera()
            : await ImageService.pickXFileFromGallery();
        if (xfile == null) {
          if (!mounted) return;
          setState(() => _isAnalyzing = false);
          return;
        }

        final bytes = await xfile.readAsBytes();
        final result = await GeminiService.analyzeImage(
          bytes,
          prompt:
              'You are a plant doctor. Analyze the uploaded plant image for diseases, pests, nutrient issues, or stress. Return a short diagnosis and 3 concise care steps. If the image is unclear, say so clearly.',
          mimeType: 'image/jpeg',
        );

        if (!mounted) return;
        setState(() {
          _scanned = true;
          _analysisText = result;
          _isAnalyzing = false;
        });

        widget.onScanComplete(
          ScanResult(
            title: 'Plant doctor analysis complete',
            subtitle: result,
            emoji: '🩺',
            colorTag: ColorTag.good,
          ),
        );
      } catch (error) {
        if (!mounted) return;
        setState(() {
          _analysisError = error.toString().replaceFirst('StateError: ', '');
          _isAnalyzing = false;
        });
      }
    }

    Future<void> _showSourcePicker() async {
      final source = await showModalBottomSheet<ImageSource>(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (sheetContext) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Scan with Plant Doctor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.camera_alt_rounded),
                  title: Text('Use camera'),
                  subtitle: Text('Take a fresh photo of the plant'),
                  onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
                ),
                ListTile(
                  leading: Icon(Icons.photo_library_rounded),
                  title: Text('Choose from gallery'),
                  subtitle: Text('Upload an existing plant photo'),
                  onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
                ),
              ],
            ),
          ),
        ),
      );

      if (!mounted || source == null || _isAnalyzing) return;
      await _pickAndAnalyzeImage(source);
    }

    @override
    Widget build(BuildContext context) {
      return _featureCard(
        context: context,
        headerGradient: [Color(0xFFE76F51), Color(0xFFF4A261)],
        headerIcon: Icons.biotech_rounded,
        headerTitle: 'AI Disease Detection',
        child: Column(
          children: [
            if (!_scanned) ...[
              GestureDetector(
                onTap: _isAnalyzing ? null : _showSourcePicker,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.3),
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isAnalyzing)
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        )
                      else
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.camera_alt_outlined,
                              size: 28, color: AppColors.secondary),
                        ),
                      SizedBox(height: 12),
                      Text(
                        _isAnalyzing ? 'Analyzing image...' : 'Tap to scan a leaf',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _isAnalyzing
                            ? 'Sending image to Gemini 2.5 Flash'
                            : 'Camera or gallery supported',
                        style: TextStyle(
                            fontSize: 12, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),
              ),
              if (_analysisError != null) ...[
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    _analysisError!,
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ],
            ] else ...[
              Container(
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Color(0xFF52B788).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Text('🩺', style: TextStyle(fontSize: 24)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plant doctor result',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            _analysisText ?? 'No analysis available.',
                            style: TextStyle(
                              fontSize: 12,
                              color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _resetScanResult,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.outline),
                        shape: StadiumBorder(),
                      ),
                      child: Text('Retake',
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isAnalyzing
                          ? null
                          : () {
                              _resetScanResult();
                              _showSourcePicker();
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                      ),
                      child: Text('Choose Another'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    }
  }

class _ARPlantPlacement extends StatelessWidget {
  final ValueChanged<ScanResult> onLaunchAr;

  _ARPlantPlacement({required this.onLaunchAr});

  @override
  Widget build(BuildContext context) {
    return _featureCard(
      context: context,
      headerGradient: [Color(0xFF6C63FF), Color(0xFF9C6FFF)],
      headerIcon: Icons.view_in_ar_rounded,
      headerTitle: 'AR Plant Placement',
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simulated AR grid
                CustomPaint(
                  size: Size(double.infinity, 140),
                  painter: _GridPainter(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Color(0x336C63FF),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color(0xFF6C63FF), width: 2),
                      ),
                      child: Icon(Icons.view_in_ar_rounded,
                          color: Colors.white, size: 24),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Preview plants in your space',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                onLaunchAr(
                  ScanResult(
                    title: 'AR placement ready',
                    subtitle: 'Previewed a 1.2m plant footprint in your room.',
                    emoji: '🪴',
                    colorTag: ColorTag.neutral,
                  ),
                );
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (_) => _ArPreviewSheet(),
                );
              },
              icon: Icon(Icons.camera_alt_outlined, size: 18),
              label: Text('Launch AR Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthPredictor extends StatelessWidget {
  _GrowthPredictor();

  static final _months = ['Now', '1mo', '3mo', '6mo', '12mo'];
  static final _heights = [0.3, 0.45, 0.6, 0.75, 0.95];

  @override
  Widget build(BuildContext context) {
    return _featureCard(
      context: context,
      headerGradient: [AppColors.secondary, AppColors.primary],
      headerIcon: Icons.trending_up_rounded,
      headerTitle: 'Growth Predictor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monstera Deliciosa — 12 month forecast',
            style: TextStyle(fontSize: 13, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_months.length, (i) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 80 * _heights[i],
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [AppColors.secondary, AppColors.chart3],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(_months[i],
                        style: TextStyle(
                            fontSize: 10, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 14),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text('📈', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Expected to grow ~45cm in 12 months with current care.',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _featureCard({
  required BuildContext context,
  required List<Color> headerGradient,
  required IconData headerIcon,
  required String headerTitle,
  required Widget child,
}) {
  return Container(
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: headerGradient),
          ),
          child: Row(
            children: [
              Icon(headerIcon, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                headerTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.all(16), child: child),
      ],
    ),
  );
}

class _RecentScansCard extends StatelessWidget {
  final List<ScanResult> recentScans;

  _RecentScansCard({required this.recentScans});

  @override
  Widget build(BuildContext context) {
    return _featureCard(
      context: context,
      headerGradient: [Color(0xFF2A9D8F), Color(0xFF52B788)],
      headerIcon: Icons.history_rounded,
      headerTitle: 'Recent Scan Activity',
      child: recentScans.isEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Your scan results will appear here after you tap the scan or AR actions.',
                style: TextStyle(fontSize: 12, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
              ),
            )
          : Column(
              children: recentScans
                  .map((scan) => Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: _ScanHistoryTile(scan: scan),
                      ))
                  .toList(),
            ),
    );
  }
}

class _ScanHistoryTile extends StatelessWidget {
  final ScanResult scan;

  _ScanHistoryTile({required this.scan});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (scan.colorTag) {
      ColorTag.good => Color(0xFFE8F6EF),
      ColorTag.warning => Color(0xFFFFF4E6),
      ColorTag.neutral => Color(0xFFE9ECFF),
    };
    final textColor = switch (scan.colorTag) {
      ColorTag.good => AppColors.secondary,
      ColorTag.warning => Color(0xFFB5651D),
      ColorTag.neutral => Color(0xFF6C63FF),
    };

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(scan.emoji, style: TextStyle(fontSize: 20)),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(scan.title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 2),
                Text(scan.subtitle,
                    style: TextStyle(
                        fontSize: 12, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(
            scan.colorTag == ColorTag.good ? 'Good' : scan.colorTag == ColorTag.warning ? 'Warning' : 'Demo',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArPreviewSheet extends StatelessWidget {
  _ArPreviewSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AR Placement Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [Color(0xFF101820), Color(0xFF1F2A44)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 44),
                    SizedBox(height: 10),
                    Text(
                      'Move your device to place the plant',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Demo mode only in the prototype',
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: StadiumBorder(),
                ),
                child: Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1;
    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

