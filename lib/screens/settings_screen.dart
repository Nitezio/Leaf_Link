import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _card(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Text(state.profileEmoji),
                ),
                title: Text(state.profileName,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Local profile stored on this device'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Vacation mode'),
                    subtitle: const Text('Pause reminders while you are away'),
                    value: state.vacationMode,
                    onChanged: state.setVacationMode,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Notifications'),
                    subtitle: const Text('Keep gentle reminder alerts on'),
                    value: state.notificationsEnabled,
                    onChanged: state.setNotificationsEnabled,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Dark mode'),
                    subtitle: const Text('Enable dark theme'),
                    value: state.isDarkMode,
                    onChanged: state.setDarkMode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prototype status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.vacationMode
                        ? 'Vacation mode is enabled. Plant reminders are softened.'
                        : 'Vacation mode is off. Care reminders stay active.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
