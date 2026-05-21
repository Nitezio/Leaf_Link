import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';
import '../models/user_stats.dart';
import '../widgets/gamification_panel.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = UserStats.mockStats;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Profile', style: Theme.of(context).textTheme.displayMedium),
                  IconButton(
                    icon: const Icon(LucideIcons.settings),
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                  ),
                ],
              ),
            ),
            // Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=400'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sarah Jenkins', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                          child: Text('Plant Whisperer', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GamificationPanel(stats: stats),
            const SizedBox(height: 24),
            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Activity', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildListTile(context, LucideIcons.history, 'Watering History'),
                  _buildListTile(context, LucideIcons.bookmark, 'Saved Plants'),
                  _buildListTile(context, LucideIcons.users, 'Friends (12)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(LucideIcons.chevronRight, color: AppColors.mutedForeground),
        onTap: () {},
      ),
    );
  }
}
