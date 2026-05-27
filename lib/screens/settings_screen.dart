import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
        title: Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _card(context,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.secondary,
                  child: Text(state.profileEmoji),
                ),
                title: Text(state.profileName,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Local profile stored on this device'),
                trailing: Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            _card(context,
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Vacation mode'),
                    subtitle: Text('Pause reminders while you are away'),
                    value: state.vacationMode,
                    onChanged: state.setVacationMode,
                  ),
                  Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Notifications'),
                    subtitle: Text('Keep gentle reminder alerts on'),
                    value: state.notificationsEnabled,
                    onChanged: state.setNotificationsEnabled,
                  ),
                  Divider(height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Dark mode'),
                    subtitle: Text('Enable dark theme'),
                    value: state.isDarkMode,
                    onChanged: state.setDarkMode,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            _card(context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prototype status',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
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

  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: child,
    );
  }
}
