import 'package:flutter/material.dart' hide Badge;
import '../models/models.dart';
import '../theme/app_theme.dart';

class GamificationPanel extends StatelessWidget {
  final int points;
  final int level;
  final int streak;
  final List<Badge> badges;

  const GamificationPanel({
    super.key,
    required this.points,
    required this.level,
    required this.streak,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    const nextLevelPoints = 500;
    final progress = (points % nextLevelPoints) / nextLevelPoints;

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
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gold, AppColors.secondary],
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.emoji_events_rounded, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Your Achievements',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Level ring + progress
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: AppColors.muted,
                            valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$level',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.foreground,
                                ),
                              ),
                              const Text(
                                'Level',
                                style: TextStyle(fontSize: 10, color: AppColors.mutedForeground),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level $level',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.foreground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: AppColors.muted,
                              valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${nextLevelPoints - (points % nextLevelPoints)} XP to Level ${level + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.gold,
                        label: 'Points',
                        value: '$points',
                        gradientColors: [
                          AppColors.gold.withOpacity(0.1),
                          AppColors.secondary.withOpacity(0.1),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        icon: Icons.bolt_rounded,
                        iconColor: AppColors.secondary,
                        label: 'Streak',
                        value: '$streak days',
                        gradientColors: [
                          AppColors.secondary.withOpacity(0.1),
                          AppColors.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Badges
                Row(
                  children: [
                    const Icon(Icons.military_tech_rounded, size: 20, color: AppColors.secondary),
                    const SizedBox(width: 6),
                    const Text(
                      'Badges',
                      style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground),
                    ),
                    const Spacer(),
                    Text(
                      '${badges.where((b) => b.unlocked).length}/${badges.length}',
                      style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: badges.map((b) => _badgeTile(b)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeTile(Badge badge) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: badge.unlocked
            ? LinearGradient(
                colors: [
                  AppColors.gold.withOpacity(0.2),
                  AppColors.secondary.withOpacity(0.2),
                ],
              )
            : null,
        color: badge.unlocked ? null : AppColors.muted,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge.unlocked ? AppColors.gold.withOpacity(0.4) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Opacity(
        opacity: badge.unlocked ? 1.0 : 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(badge.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              badge.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
