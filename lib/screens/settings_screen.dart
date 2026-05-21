import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.foreground),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Settings', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Preferences'),
          _buildSwitchTile('Push Notifications', true),
          _buildSwitchTile('Watering Reminders', true),
          _buildSwitchTile('Dark Mode', false), // Since it's light themed mostly right now
          const SizedBox(height: 24),
          _buildSectionHeader('Account'),
          _buildListTile('Edit Profile', LucideIcons.user),
          _buildListTile('Privacy Security', LucideIcons.shield),
          _buildListTile('Data Export', LucideIcons.download),
          const SizedBox(height: 24),
          _buildSectionHeader('Support'),
          _buildListTile('Help Center', LucideIcons.helpCircle),
          _buildListTile('About PlantCare Pro', LucideIcons.info),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.destructive.withValues(alpha: 0.1),
              foregroundColor: AppColors.destructive,
              elevation: 0,
            ),
            child: const Text('Log Out'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.mutedForeground, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: value,
        onChanged: (v) {},
        activeThumbColor: AppColors.primary,
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColors.mutedForeground),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(LucideIcons.chevronRight, color: AppColors.mutedForeground),
        onTap: () {},
      ),
    );
  }
}
