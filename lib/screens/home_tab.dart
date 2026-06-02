import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/plant_card.dart';
import '../widgets/weather_panel.dart';
import '../widgets/responsive_body.dart';
import 'garden_tab.dart';
import 'plant_detail_screen.dart';
import '../widgets/plant_form_sheet.dart';

class HomeTab extends StatelessWidget {
  final VoidCallback onGoToScan;
  HomeTab({super.key, required this.onGoToScan});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ResponsiveBody(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                children: [
                  // Logo + greeting
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.eco_rounded,
                        color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good Morning',
                          style: TextStyle(
                              fontSize: 13, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  _iconBtn(context, Icons.search_rounded),
                  SizedBox(width: 8),
                  Stack(
                    children: [
                      _iconBtn(context, Icons.notifications_none_rounded),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _statCard(
                      context,
                      '${state.plants.length}',
                      'Plants',
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GardenTab(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _statCard(context, '${state.userStats.streak}', 'Day Streak'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _statCard(context, '${state.userStats.level}', 'Level'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Weather
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: WeatherPanel(),
            ),
            SizedBox(height: 20),

            // Plants
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Plants',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
                    tooltip: 'Add new plant',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => PlantFormSheet(),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            ...state.plants.map((plant) => Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: PlantCard(
                    plant: plant,
                    onWater: (id) {
                      state.waterPlant(id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Plant watered! +50 XP 🌱'),
                          backgroundColor: AppColors.secondary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      );
                    },
                    onScan: (_) => onGoToScan(),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlantDetailScreen(plantId: plant.id),
                        ),
                      );
                    },
                  ),
                )),

            // Quick actions
            Padding(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Text(
                'Quick Actions',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      context: context,
                      icon: Icons.camera_alt_outlined,
                      title: 'AR Preview',
                      sub: 'Place plants in AR',
                      onTap: onGoToScan,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _quickAction(
                      context: context,
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
      ),
    );
  }

  static Widget _iconBtn(BuildContext context, IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Icon(icon, size: 20, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
    );
  }

  static Widget _statCard(BuildContext context, String value, String label, {VoidCallback? onTap}) {
    final card = Container(
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
          Text(value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              )),
          SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 11, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
        ],
      ),
    );
    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }

  static Widget _quickAction({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String sub,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.secondary, size: 22),
            ),
            SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface,
                )),
            SizedBox(height: 2),
            Text(sub,
                style: TextStyle(
                    fontSize: 11, color: (Theme.of(context).textTheme.bodySmall?.color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)))),
          ],
        ),
      ),
    );
  }
}

