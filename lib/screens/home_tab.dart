import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/plant_card.dart';
import '../widgets/weather_panel.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onGoToScan;
  const HomeTab({super.key, required this.onGoToScan});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                // Logo + greeting
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.eco_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good Morning',
                        style: TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _iconBtn(Icons.search_rounded),
                const SizedBox(width: 8),
                Stack(
                  children: [
                    _iconBtn(Icons.notifications_none_rounded),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.destructive,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _statCard('${state.plants.length}', 'Plants')),
                const SizedBox(width: 10),
                Expanded(child: _statCard('${state.userStats.streak}', 'Day Streak')),
                const SizedBox(width: 10),
                Expanded(child: _statCard('${state.userStats.level}', 'Level')),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Weather
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: WeatherPanel(),
          ),
          const SizedBox(height: 20),

          // Plants
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your Plants',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.foreground),
            ),
          ),
          const SizedBox(height: 12),
          ...state.plants.map((plant) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: PlantCard(
                  plant: plant,
                  onWater: (id) {
                    state.waterPlant(id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Plant watered! +50 XP 🌱'),
                        backgroundColor: AppColors.secondary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    );
                  },
                  onScan: (_) => onGoToScan(),
                ),
              )),

          // Quick actions
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Text(
              'Quick Actions',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.mutedForeground),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                Expanded(
                  child: _quickAction(
                    icon: Icons.camera_alt_outlined,
                    title: 'AR Preview',
                    sub: 'Place plants in AR',
                    onTap: onGoToScan,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _quickAction(
                    icon: Icons.trending_up_rounded,
                    title: 'Growth Predict',
                    sub: 'See future growth',
                    onTap: onGoToScan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _iconBtn(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.card,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 20, color: AppColors.mutedForeground),
    );
  }

  static Widget _statCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
              )),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
        ],
      ),
    );
  }

  static Widget _quickAction({
    required IconData icon,
    required String title,
    required String sub,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.secondary, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.foreground,
                )),
            const SizedBox(height: 2),
            Text(sub,
                style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}
