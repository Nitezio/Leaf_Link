enum PlantHealth { excellent, good, warning }

class Plant {
  final String id;
  final String name;
  final String species;
  final String image;
  String lastWatered;
  String nextWatering;
  PlantHealth health;
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
    String? lastWatered,
    String? nextWatering,
    PlantHealth? health,
  }) {
    return Plant(
      id: id,
      name: name,
      species: species,
      image: image,
      level: level,
      lastWatered: lastWatered ?? this.lastWatered,
      nextWatering: nextWatering ?? this.nextWatering,
      health: health ?? this.health,
    );
  }
}

class Badge {
  final String id;
  final String name;
  final String icon;
  final bool unlocked;

  const Badge({
    required this.id,
    required this.name,
    required this.icon,
    required this.unlocked,
  });
}

class UserStats {
  int points;
  int level;
  int streak;
  List<Badge> badges;

  UserStats({
    required this.points,
    required this.level,
    required this.streak,
    required this.badges,
  });
}
