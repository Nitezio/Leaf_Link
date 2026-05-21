import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../models/plant.dart';
import '../models/user_stats.dart';
import '../widgets/plant_card.dart';
import '../widgets/weather_panel.dart';
import '../widgets/quick_action_card.dart';
import 'my_garden_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final plants = Plant.mockPlants;
  final stats = UserStats.mockStats;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.secondary, AppColors.primary]),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: AppColors.primary.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: const Icon(LucideIcons.leaf, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good Morning', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedForeground)),
                          Text('Welcome back!', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildHeaderIcon(LucideIcons.search),
                      const SizedBox(width: 8),
                      Stack(
                        children: [
                          _buildHeaderIcon(LucideIcons.bell),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.destructive, shape: BoxShape.circle)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: _buildStatCard(context, '${plants.length}', 'Plants')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, '${stats.streak}', 'Day Streak')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, '${stats.level}', 'Level')),
                ],
              ),
            ),
            const WeatherPanel(),
            // Featured Plants
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Plants', style: Theme.of(context).textTheme.titleLarge),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyGardenScreen())),
                    child: Text('View All', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: plants.map((plant) => PlantCard(plant: plant, onWater: () {}, onScan: () {})).toList(),
              ),
            ),
            // Quick Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text('Quick Actions', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.mutedForeground)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(child: QuickActionCard(icon: LucideIcons.camera, title: 'AR Preview', description: 'Place plants in AR', onClick: () {})),
                  const SizedBox(width: 12),
                  Expanded(child: QuickActionCard(icon: LucideIcons.trendingUp, title: 'Growth Predict', description: 'See future growth', onClick: () {})),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: AppColors.card, border: Border.all(color: AppColors.border), shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.mutedForeground, size: 20),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.mutedForeground)),
        ],
      ),
    );
  }
}
