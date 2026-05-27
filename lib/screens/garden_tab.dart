import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import 'add_edit_plant_screen.dart';
import 'plant_detail_screen.dart';
import '../widgets/plant_card.dart';
import '../widgets/responsive_body.dart';

class GardenTab extends StatelessWidget {
  GardenTab({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return ResponsiveBody(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Garden',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(Icons.add_rounded,
                          color: Colors.white, size: 22),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddEditPlantScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['All', 'Thriving', 'Needs Care', 'New'].map((label) {
                  final isAll = label == 'All';
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isAll ? AppColors.primary : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isAll ? AppColors.primary : Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isAll ? Colors.white : Theme.of(context).colorScheme.onSurface,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 16),

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
                    onScan: (_) {},
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
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
