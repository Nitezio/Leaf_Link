import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDiseaseDetection(context),
            const SizedBox(height: 16),
            _buildARPlacement(context),
            const SizedBox(height: 16),
            _buildGrowthPredictor(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseDetection(BuildContext context) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.camera, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Plant Health Scanner', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          Text('Detect • Treat • Monitor', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedForeground)),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.muted.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, style: BorderStyle.solid),
              ),
              child: const Center(child: Icon(LucideIcons.scanLine, size: 48, color: AppColors.mutedForeground)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Scan Now'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 56)),
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildARPlacement(BuildContext context) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.scanLine, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('AR Plant Placement', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: Text('Beta', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.muted, AppColors.background]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(LucideIcons.camera, color: AppColors.mutedForeground),
                    SizedBox(height: 8),
                    Text('See Before You Plant', style: TextStyle(color: AppColors.mutedForeground)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('💡 Point your camera at the floor or a flat surface...', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedForeground)),
        ],
      ),
    );
  }

  Widget _buildGrowthPredictor(BuildContext context) {
    return _buildCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.trendingUp, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('AI Growth Predictor', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          Text('Timelapse simulation', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedForeground)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(color: AppColors.muted, borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('Before')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Center(child: Text('After (6 mo)', style: TextStyle(fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Slider(value: 6, min: 1, max: 12, divisions: 11, label: '6 months', onChanged: (v) {}),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
            child: const Text('View Full Timeline'),
          ),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }
}
