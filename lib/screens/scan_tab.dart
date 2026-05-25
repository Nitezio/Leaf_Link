import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ScanTab extends StatelessWidget {
  const ScanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        children: [
          const _DiseaseDetection(),
          const SizedBox(height: 16),
          const _ARPlantPlacement(),
          const SizedBox(height: 16),
          const _GrowthPredictor(),
        ],
      ),
    );
  }
}

class _DiseaseDetection extends StatefulWidget {
  const _DiseaseDetection();

  @override
  State<_DiseaseDetection> createState() => _DiseaseDetectionState();
}

class _DiseaseDetectionState extends State<_DiseaseDetection> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return _featureCard(
      headerGradient: const [Color(0xFFE76F51), Color(0xFFF4A261)],
      headerIcon: Icons.biotech_rounded,
      headerTitle: 'AI Disease Detection',
      child: Column(
        children: [
          if (!_scanned) ...[
            GestureDetector(
              onTap: () => setState(() => _scanned = true),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.muted,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.secondary.withOpacity(0.3),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tap to scan a leaf',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Point camera at any plant issue',
                      style: TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF52B788).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Text('✅', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Plant looks healthy!',
                            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground)),
                        Text('No disease detected. Keep up the good care.',
                            style: TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => _scanned = false),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.border),
                  shape: const StadiumBorder(),
                ),
                child: const Text('Scan Again', style: TextStyle(color: AppColors.foreground)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ARPlantPlacement extends StatelessWidget {
  const _ARPlantPlacement();

  @override
  Widget build(BuildContext context) {
    return _featureCard(
      headerGradient: const [Color(0xFF6C63FF), Color(0xFF9C6FFF)],
      headerIcon: Icons.view_in_ar_rounded,
      headerTitle: 'AR Plant Placement',
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1a1a2e), Color(0xFF16213e)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Simulated AR grid
                CustomPaint(
                  size: const Size(double.infinity, 140),
                  painter: _GridPainter(),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0x336C63FF),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF6C63FF), width: 2),
                      ),
                      child: const Icon(Icons.view_in_ar_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Preview plants in your space',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined, size: 18),
              label: const Text('Launch AR Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthPredictor extends StatelessWidget {
  const _GrowthPredictor();

  static const _months = ['Now', '1mo', '3mo', '6mo', '12mo'];
  static const _heights = [0.3, 0.45, 0.6, 0.75, 0.95];

  @override
  Widget build(BuildContext context) {
    return _featureCard(
      headerGradient: const [AppColors.secondary, AppColors.primary],
      headerIcon: Icons.trending_up_rounded,
      headerTitle: 'Growth Predictor',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monstera Deliciosa — 12 month forecast',
            style: TextStyle(fontSize: 13, color: AppColors.mutedForeground),
          ),
          const SizedBox(height: 16),
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
                    const SizedBox(height: 6),
                    Text(_months[i],
                        style: const TextStyle(fontSize: 10, color: AppColors.mutedForeground)),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Text('📈', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Expected to grow ~45cm in 12 months with current care.',
                    style: TextStyle(fontSize: 12, color: AppColors.foreground),
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
  required List<Color> headerGradient,
  required IconData headerIcon,
  required String headerTitle,
  required Widget child,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: AppColors.primary.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    clipBehavior: Clip.hardEdge,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: headerGradient),
          ),
          child: Row(
            children: [
              Icon(headerIcon, color: Colors.white, size: 22),
              const SizedBox(width: 8),
              Text(
                headerTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Padding(padding: const EdgeInsets.all(16), child: child),
      ],
    ),
  );
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.07)
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
