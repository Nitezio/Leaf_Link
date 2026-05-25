import 'package:flutter/material.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  List<Plant> plants = [
    Plant(
      id: '1',
      name: 'Monstera Deliciosa',
      species: 'Swiss Cheese Plant',
      image: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400',
      lastWatered: '2 days ago',
      nextWatering: 'Tomorrow',
      health: PlantHealth.excellent,
      level: 5,
    ),
    Plant(
      id: '2',
      name: 'Golden Pothos',
      species: 'Epipremnum aureum',
      image: 'https://images.unsplash.com/photo-1632207691143-643e2753a2c4?w=400',
      lastWatered: 'Yesterday',
      nextWatering: 'In 2 days',
      health: PlantHealth.good,
      level: 3,
    ),
    Plant(
      id: '3',
      name: 'Snake Plant',
      species: 'Sansevieria trifasciata',
      image: 'https://images.unsplash.com/photo-1593482892290-d86fe3016e13?w=400',
      lastWatered: '5 days ago',
      nextWatering: 'Today',
      health: PlantHealth.warning,
      level: 4,
    ),
  ];

  UserStats userStats = UserStats(
    points: 3450,
    level: 12,
    streak: 15,
    badges: const [
      Badge(id: '1', name: 'Green Thumb', icon: '🌱', unlocked: true),
      Badge(id: '2', name: 'Caretaker', icon: '💚', unlocked: true),
      Badge(id: '3', name: 'Streak Master', icon: '🔥', unlocked: true),
      Badge(id: '4', name: 'Plant Doctor', icon: '🩺', unlocked: true),
      Badge(id: '5', name: 'Collector', icon: '🏆', unlocked: false),
      Badge(id: '6', name: 'Social Butterfly', icon: '🦋', unlocked: false),
      Badge(id: '7', name: 'Trader', icon: '🤝', unlocked: false),
      Badge(id: '8', name: 'Master Gardener', icon: '👑', unlocked: false),
    ],
  );

  void waterPlant(String id) {
    final idx = plants.indexWhere((p) => p.id == id);
    if (idx != -1) {
      plants[idx] = plants[idx].copyWith(
        lastWatered: 'Just now',
        nextWatering: 'In 3 days',
        health: PlantHealth.excellent,
      );
      userStats.points += 50;
      userStats.streak += 1;
      notifyListeners();
    }
  }
}
