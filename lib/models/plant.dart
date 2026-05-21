enum PlantHealth { excellent, good, warning, critical }

class Plant {
  final String id;
  final String name;
  final String species;
  final String image;
  final String lastWatered;
  final String nextWatering;
  final PlantHealth health;
  final int level;

  Plant({
    required this.id,
    required this.name,
    required this.species,
    required this.image,
    required this.lastWatered,
    required this.nextWatering,
    required this.health,
    required this.level,
  });

  Plant copyWith({
    String? id,
    String? name,
    String? species,
    String? image,
    String? lastWatered,
    String? nextWatering,
    PlantHealth? health,
    int? level,
  }) {
    return Plant(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      image: image ?? this.image,
      lastWatered: lastWatered ?? this.lastWatered,
      nextWatering: nextWatering ?? this.nextWatering,
      health: health ?? this.health,
      level: level ?? this.level,
    );
  }

  // Mock data factory
  static List<Plant> get mockPlants => [
        Plant(
          id: "1",
          name: "Monstera Deliciosa",
          species: "Swiss Cheese Plant",
          image: "https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400",
          lastWatered: "2 days ago",
          nextWatering: "Tomorrow",
          health: PlantHealth.excellent,
          level: 5,
        ),
        Plant(
          id: "2",
          name: "Golden Pothos",
          species: "Epipremnum aureum",
          image: "https://images.unsplash.com/photo-1632207691143-643e2753a2c4?w=400",
          lastWatered: "Yesterday",
          nextWatering: "In 2 days",
          health: PlantHealth.good,
          level: 3,
        ),
        Plant(
          id: "3",
          name: "Snake Plant",
          species: "Sansevieria trifasciata",
          image: "https://images.unsplash.com/photo-1593482892290-d86fe3016e13?w=400",
          lastWatered: "5 days ago",
          nextWatering: "Today",
          health: PlantHealth.warning,
          level: 4,
        ),
      ];
}
