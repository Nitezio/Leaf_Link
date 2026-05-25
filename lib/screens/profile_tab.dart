import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/gamification_panel.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _vacationMode = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final stats = state.userStats;
    const nextLevel = 500;
    final progress = (stats.points % nextLevel) / nextLevel;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile header (dark green)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
            color: AppColors.primary,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🌿', style: TextStyle(fontSize: 32)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Plant Parent',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Level ${stats.level} Gardener',
                            style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Level progress card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Level ${stats.level}',
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                          Text('Level ${stats.level + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${nextLevel - (stats.points % nextLevel)} XP to next level',
                        style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                _statCard(Icons.eco_rounded, '${state.plants.length}', 'Plants'),
                const SizedBox(width: 10),
                _statCard(Icons.trending_up_rounded, '${stats.points}', 'Points'),
                const SizedBox(width: 10),
                _statCard(Icons.calendar_today_rounded, '${stats.streak}', 'Day Streak'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Vacation mode
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _vacationMode = !_vacationMode),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.flight_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Vacation Mode',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  )),
                              Text('Share your garden with a friend',
                                  style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 12)),
                            ],
                          ),
                        ),
                        Icon(
                          _vacationMode ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_vacationMode) ...[
                  const SizedBox(height: 12),
                  _VacationPanel(),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Gamification
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GamificationPanel(
              points: stats.points,
              level: stats.level,
              streak: stats.streak,
              badges: stats.badges,
            ),
          ),
          const SizedBox(height: 16),

          // Sign out
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, color: AppColors.destructive),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(color: AppColors.destructive, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
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
            Icon(icon, color: AppColors.secondary, size: 22),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.foreground)),
            Text(label,
                style: const TextStyle(fontSize: 10, color: AppColors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}

class _VacationPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Share Garden Access',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.foreground),
          ),
          const SizedBox(height: 10),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                SizedBox(width: 14),
                Icon(Icons.mail_outline_rounded, size: 18, color: AppColors.mutedForeground),
                SizedBox(width: 8),
                Text("Friend's email address",
                    style: TextStyle(color: AppColors.mutedForeground, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text('Send Invite'),
            ),
          ),
        ],
      ),
    );
  }
}
