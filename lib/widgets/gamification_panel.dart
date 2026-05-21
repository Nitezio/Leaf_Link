import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../models/user_stats.dart';

class GamificationPanel extends StatelessWidget {
  final UserStats stats;

  const GamificationPanel({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.trophy, color: AppColors.gold, size: 24),
              const SizedBox(width: 8),
              Text(
                'Your Achievements',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              // Circular progress mock
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircularProgressIndicator(
                      value: 0.9, // Mock progress
                      strokeWidth: 8,
                      backgroundColor: AppColors.muted,
                      color: AppColors.secondary,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Lv.${stats.level}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stats.points} XP Total',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '50 XP to next level',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedForeground),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.9, // 450/500
                      backgroundColor: AppColors.muted,
                      color: AppColors.gold,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, LucideIcons.star, AppColors.gold, '${stats.points}', 'Points')),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(context, LucideIcons.zap, AppColors.secondary, '${stats.streak}', 'Day Streak')),
            ],
          ),
          const SizedBox(height: 24),
          Text('Badges', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: stats.badges.length,
            itemBuilder: (context, index) {
              final badge = stats.badges[index];
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: badge.unlocked ? AppColors.gold.withValues(alpha: 0.2) : AppColors.muted,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        badge.icon,
                        style: TextStyle(
                          fontSize: 24,
                          color: badge.unlocked ? Colors.white : Colors.transparent, // Opacity handling
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badge.name,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: badge.unlocked ? AppColors.foreground : AppColors.mutedForeground,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, Color color, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text(label, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
