import 'package:flutter/material.dart' hide Badge;
import '../models/models.dart';
import '../theme/app_theme.dart';

class GamificationPanel extends StatelessWidget {
  final int points;
  final int level;
  final int streak;
  final List<Badge> badges;

  GamificationPanel({
    super.key,
    required this.points,
    required this.level,
    required this.streak,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    final nextLevelPoints = 500;
    final progress = (points % nextLevelPoints) / nextLevelPoints;

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
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gold, AppColors.secondary],
              ),
            ),
            child: Row(
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
            padding: EdgeInsets.all(16),
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
                            backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                            valueColor: AlwaysStoppedAnimation(AppColors.secondary),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$level',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Level',
                                style: TextStyle(fontSize: 10, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Level $level',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                              valueColor: AlwaysStoppedAnimation(AppColors.secondary),
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '${nextLevelPoints - (points % nextLevelPoints)} XP to Level ${level + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Stats grid
                Row(
                  children: [
                    Expanded(
                      child: _statCard(
                        context: context,
                        icon: Icons.star_rounded,
                        iconColor: AppColors.gold,
                        label: 'Points',
                        value: '$points',
                        gradientColors: [
                          AppColors.gold.withValues(alpha: 0.1),
                          AppColors.secondary.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _statCard(
                        context: context,
                        icon: Icons.bolt_rounded,
                        iconColor: AppColors.secondary,
                        label: 'Streak',
                        value: '$streak days',
                        gradientColors: [
                          AppColors.secondary.withValues(alpha: 0.1),
                          AppColors.primary.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Badges
                Row(
                  children: [
                    Icon(Icons.military_tech_rounded, size: 20, color: AppColors.secondary),
                    SizedBox(width: 6),
                    Text(
                      'Badges',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    Spacer(),
                    Text(
                      '${badges.where((b) => b.unlocked).length}/${badges.length}',
                      style: TextStyle(fontSize: 12, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: badges.map((b) => _badgeTile(context, b)).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required List<Color> gradientColors,
  }) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: iconColor.withValues(alpha: 0.2)),
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
              SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 11, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeTile(BuildContext context, Badge badge) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: badge.unlocked
            ? LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.2),
                  AppColors.secondary.withValues(alpha: 0.2),
                ],
              )
            : null,
        color: badge.unlocked ? null : Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge.unlocked ? AppColors.gold.withValues(alpha: 0.4) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Opacity(
        opacity: badge.unlocked ? 1.0 : 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(badge.icon, style: TextStyle(fontSize: 22)),
            SizedBox(height: 2),
            Text(
              badge.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

