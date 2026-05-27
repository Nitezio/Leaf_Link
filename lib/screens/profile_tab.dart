import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/gamification_panel.dart';
import '../widgets/responsive_body.dart';
import 'settings_screen.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final stats = state.userStats;
    final nextLevel = 500;
    final progress = (stats.points % nextLevel) / nextLevel;

    return ResponsiveBody(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header (dark green)
            Container(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
              color: AppColors.primary,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(state.profileEmoji,
                              style: TextStyle(fontSize: 32)),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.profileName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Level ${stats.level} Gardener',
                              style: TextStyle(
                                  color: Color(0xCCFFFFFF), fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SettingsScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.settings_outlined,
                            color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Level progress card
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Level ${stats.level}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            Text('Level ${stats.level + 1}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.white.withValues(alpha: 0.2),
                            valueColor:
                                AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          '${nextLevel - (stats.points % nextLevel)} XP to next level',
                          style: TextStyle(
                              color: Color(0xB3FFFFFF), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  _statCard(
                      Icons.eco_rounded, '${state.plants.length}', 'Plants'),
                  SizedBox(width: 10),
                  _statCard(
                      Icons.trending_up_rounded, '${stats.points}', 'Points'),
                  SizedBox(width: 10),
                  _statCard(Icons.calendar_today_rounded, '${stats.streak}',
                      'Day Streak'),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Vacation mode
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => state.setVacationMode(!state.vacationMode),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.secondary, AppColors.primary],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.flight_rounded,
                                color: Colors.white, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
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
                                    style: TextStyle(
                                        color: Color(0xCCFFFFFF),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Icon(
                            state.vacationMode
                                ? Icons.expand_less_rounded
                                : Icons.expand_more_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.vacationMode) ...[
                    SizedBox(height: 12),
                    _VacationPanel(),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16),

            // Gamification
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GamificationPanel(
                points: stats.points,
                level: stats.level,
                streak: stats.streak,
                badges: stats.badges,
              ),
            ),
            SizedBox(height: 16),

            // Sign out
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton.icon(
                  onPressed: () async {
                    await context.read<AppState>().signOutLocal();
                  },
                  icon: Icon(Icons.logout_rounded,
                      color: AppColors.destructive),
                  label: Text(
                    'Sign Out',
                    style: TextStyle(
                        color: AppColors.destructive,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.secondary, size: 22),
            SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface)),
            Text(label,
                style: TextStyle(
                    fontSize: 10, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Share Garden Access',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(height: 10),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              children: [
                SizedBox(width: 14),
                Icon(Icons.mail_outline_rounded,
                    size: 18, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                SizedBox(width: 8),
                Text("Friend's email address",
                    style: TextStyle(
                        color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)), fontSize: 13)),
              ],
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: StadiumBorder(),
              ),
              child: Text('Send Invite'),
            ),
          ),
        ],
      ),
    );
  }
}

